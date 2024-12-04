//
//  ECGInstructVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

class ECGInstructVC: BaseViewController {
    // MARK: Property

    var dataSource: [ECGModel] = []
    let healthStore = HKHealthStore()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Lazy Get

    lazy var mainView: ECGInstructView = {
        let view = ECGInstructView()
        view.delegate = self
        return view
    }()
}

// MARK: - ECGInstructViewDelegate

extension ECGInstructVC: ECGInstructViewDelegate {
    func getEcgData() {
        requestData()
    }
}

extension ECGInstructVC {
    private func noDataObtained() {
        let alert = EMAlertController(title: "No data was obtained, please retest.", message: "Note: Please ensure that the test has been conducted within the last hour.")
        alert.cornerRadius = 10
        alert.titleColor = UIColor(hexString: "#2A2B2F")
        alert.messageColor = UIColor(hexString: "#9699A6")
        let cancel = EMAlertAction(title: "Cancel", style: .cancel, isShowRightSeparator: true)
        cancel.titleFont = UIFont.regular(15)
        cancel.titleColor = UIColor(hexString: "#666973")
        let confirm = EMAlertAction(title: "Retest", style: .normal, isShowLeftSeparator: true) {
            // Perform Action
        }
        confirm.titleFont = UIFont.regular(15)
        confirm.titleColor = UIColor(hexString: "#FF6770")
        alert.addAction(cancel)
        alert.addAction(confirm)
        alert.buttonSpacing = 0
        present(alert, animated: true, completion: nil)
    }

    private func requestData() {
        Loading.showLoading(to: view)
        var counter = 0
        let healthKitTypes: Set = [HKObjectType.electrocardiogramType()]
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypes) { bool, error in
            if bool {
                // authorization succesful
                self.getECGsCount { ecgsCount in
                    if ecgsCount < 1 {
                        print("You have no ecgs available")
                        DispatchQueue.main.async {
                            Loading.hideLoading(from: self.view)
                            Loading.showToast(with: "You have no ecgs available", to: self.view)
                            self.noDataObtained()
                        }
                        return
                    } else {
                        for i in 0 ... ecgsCount - 1 {
                            self.getECGs(counter: i) { ecgModel in
                                DispatchQueue.main.async {
                                    self.dataSource.append(ecgModel)
                                    counter += 1
                                    // the last thread will enter here, meaning all of them are finished
                                    if counter == ecgsCount {
                                        if let model = self.dataSource.first {
                                            let authView = ECGMeasureResultView()
                                            authView.refresh(model: model)
                                            kWindow?.addSubview(authView)
                                            authView.snp.makeConstraints { make in
                                                make.edges.equalToSuperview()
                                            }
                                        }
                                        Loading.hideLoading(from: self.view)
                                    }
                                }
                            }
                        }
                    }
                }

            } else {
                print("We had an error here: \n\(String(describing: error))")
            }
        }
    }

    func getECGsCount(completion: @escaping (Int) -> Void) {
        var result = 0

        let earlyDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: earlyDate, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let ecgQuery = HKSampleQuery(sampleType: HKObjectType.electrocardiogramType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let samples = samples
            else {
                return
            }
            result = samples.count
            completion(result)
        }
        healthStore.execute(ecgQuery)
    }

    func getECGs(counter: Int, completion: @escaping (ECGModel) -> Void) {
        var ecgSamples = [(Double, Double)]()
        var ecgModel = ECGModel()
//        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date.distantFuture, options: .strictEndDate)
        let earlyDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: earlyDate, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let ecgQuery = HKSampleQuery(sampleType: HKObjectType.electrocardiogramType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let samples = samples, let currentSample = samples[counter] as? HKElectrocardiogram else {
                return
            }

            let query = HKElectrocardiogramQuery(samples[counter] as! HKElectrocardiogram) { _, result in

                switch result {
                case let .error(error):
                    print("error: ", error)

                case let .measurement(value):
                    let sample = (value.quantity(for: .appleWatchSimilarToLeadI)!.doubleValue(for: HKUnit.volt()), value.timeSinceSampleStart)
                    ecgSamples.append(sample)

                case .done:
                    // print("done")
                    DispatchQueue.main.async {
                        ecgModel.ecgData = ecgSamples.map { $0.0 }
                        ecgModel.startTimeStamp = Double(samples[counter].startDate.timeIntervalSince1970)
                        ecgModel.endTimeStamp = Double(samples[counter].endDate.timeIntervalSince1970)
                        ecgModel.sourceDevice = "Apple Watch"
                        if let averageHeartRate = currentSample.averageHeartRate?.doubleValue(for: HKUnit(from: "count/min")) {
                            ecgModel.averageHeartRate = Int(averageHeartRate)
                        }
                        ecgModel.classification = currentSample.classification.rawValue
                        ecgModel.samplingFrequency = currentSample.samplingFrequency?.doubleValue(for: HKUnit.hertz())
                        ecgModel.numberOfVoltageMeasurements = currentSample.numberOfVoltageMeasurements
                        completion(ecgModel)
                    }

                @unknown default:
                    break
                }
            }

            self.healthStore.execute(query)
        }

        healthStore.execute(ecgQuery)
    }
}

// MARK: - UI

extension ECGInstructVC {
    private func setupUI() {
        title = "Get ECG Data"
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
