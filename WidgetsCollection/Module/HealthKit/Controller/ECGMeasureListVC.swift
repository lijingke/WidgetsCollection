//
//  ECGMeasureListVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

class ECGMeasureListVC: UIViewController {
    // MARK: Property

    let healthStore = HKHealthStore()
    var dataSource: [ECGModel] = []

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }

    // MARK: Lazy Get

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.register(ECGMeasureListCell.self, forCellReuseIdentifier: ECGMeasureListCell.identifier)
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        return table
    }()

    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    lazy var goTestBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Go to test", for: .normal)
        btn.backgroundColor = UIColor(hexString: "#FF6770")
        btn.titleLabel?.font = UIFont.regular(16)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 24
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return btn
    }()
}

// MARK: - Event

extension ECGMeasureListVC {
    @objc func btnAction() {
        let vc = ECGInstructVC()
        navigationController?.pushViewController(vc, animated: true)
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
                        LogUtil.log("You have no ecgs available")
                        DispatchQueue.main.async {
                            Loading.hideLoading(from: self.view)
                            Loading.showToast(with: "You have no ecgs available", to: self.view)
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
                                        self.tableView.reloadData()
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
//        let predicate = HKQuery.predicateForSamples(withStart: earlyDate, end: Date(), options: .strictEndDate)
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date.distantFuture, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let ecgQuery = HKSampleQuery(sampleType: HKObjectType.electrocardiogramType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let samples = samples else {
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
        let earlyDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())

        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date.distantFuture, options: .strictEndDate)
//        let predicate = HKQuery.predicateForSamples(withStart: earlyDate, end: Date(), options: .strictEndDate)

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

extension ECGMeasureListVC {
    private func setupUI() {
        title = "Electrocardiograms (ECG)"

        view.addSubviews([tableView, bottomView])
        bottomView.addSubview(goTestBtn)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(68)
        }
        goTestBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(48)
        }
    }
}

// MARK: - UITableViewDelegate

extension ECGMeasureListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ECGDetitalVC()
        vc.model = dataSource[indexPath.section]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ECGMeasureListVC: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ECGMeasureListCell.identifier, for: indexPath) as? ECGMeasureListCell else { return UITableViewCell() }
        let model = dataSource[indexPath.section]
        cell.refresh(model: model)
        return cell
    }
}
