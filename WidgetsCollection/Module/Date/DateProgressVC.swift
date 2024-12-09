//
//  DateProgressVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/9.
//

import Foundation
import SwiftDate
import UIKit

class DateProgressVC: BaseViewController {
    // MARK: Property

    private var totalDay: Int = 0
    private var pastDay: Int = 0
    private var remainDay: Int = 0

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .all
        view.layer.contents = R.image.bg()!.cgImage
        initData()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }

    override func getNavigatorConfig() -> NavigatorConfig? {
        return NavigatorConfig.newConfig().isTranslucent(true)
    }

    // MARK: Lazy Get

    lazy var progressRing: UICircularProgressRing = {
        let ring = UICircularProgressRing()
        ring.delegate = self
        ring.startAngle = 270
        ring.style = .ontop
        ring.outerRingWidth = 10
        ring.innerRingWidth = 20
        ring.outerRingColor = UIColor(hexString: "#CFD2D2")
        ring.innerRingColor = kThemeColor
        var formatter = UICircularProgressRingFormatter()
        formatter.showFloatingPoint = true
        ring.valueFormatter = formatter
        return ring
    }()

    lazy var totalDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold(17)
        return label
    }()

    lazy var pastDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold(17)
        return label
    }()

    lazy var remainDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold(17)
        return label
    }()

    lazy var fourDollarDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold(17)
        return label
    }()

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        return picker
    }()

    lazy var jumpBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("更新倒计时", for: .normal)
        btn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(color: kThemeColor), for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()
}

// MARK: - Event

extension DateProgressVC {
    @objc func btnAction(sender: UIButton) {
        let comeDate = "2024-10-12".toDate() ?? DateInRegion(Date(), region: .current)
        let currentDate = "2024-12-25".toDate() ?? DateInRegion(Date(), region: .current)
        pastDay = currentDate.difference(in: .day, from: comeDate) ?? 0
        let progress = CGFloat(pastDay) / CGFloat(totalDay)
        DispatchQueue.main.async {
            self.progressRing.startProgress(to: progress * 100, duration: 1)
        }
    }

    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
        // do something here
        Log.info("Choosed Date is: \(datePicker.date)")

        UIView.animate(withDuration: 0.5) {
            self.presentedViewController?.view.alpha = 0
        } completion: { _ in
            self.presentedViewController?.dismiss(animated: true, completion: nil)
            self.updateProgress(withData: datePicker.date)
        }
    }

    private func updateProgress(withData date: Date) {
        let comeDate = "2024-10-12".toDate() ?? DateInRegion(Date(), region: .current)
        let currentDate = DateInRegion(date, region: .current)
        pastDay = currentDate.difference(in: .day, from: comeDate) ?? 0
        let progress = CGFloat(pastDay) / CGFloat(totalDay)
        DispatchQueue.main.async {
            self.progressRing.startProgress(to: progress * 100, duration: 1)
        }
    }
}

// MARK: - UICircularProgressRingDelegate

extension DateProgressVC: UICircularProgressRingDelegate {
    func didFinishProgress(for ring: UICircularProgressRing) {}

    func didPauseProgress(for ring: UICircularProgressRing) {}

    func didContinueProgress(for ring: UICircularProgressRing) {}

    func didUpdateProgressValue(for ring: UICircularProgressRing, to newValue: CGFloat) {
        LogUtil.log(newValue.description)
    }

    func willDisplayLabel(for ring: UICircularProgressRing, _ label: UILabel) {
        label.font = UIFont.semibold(45)
        label.textColor = kThemeColor
    }
}

// MARK: - Data

extension DateProgressVC {
    private func initData() {
        let comeDate = "2024-10-12".toDate() ?? DateInRegion(Date(), region: .current)
        let goDate = "2025-04-16".toDate() ?? DateInRegion(Date(), region: .current)
        let currentDate = DateInRegion(Date(), region: .current)
        pastDay = currentDate.difference(in: .day, from: comeDate) ?? 0
        remainDay = goDate.difference(in: .day, from: currentDate) ?? 0
        totalDay = goDate.difference(in: .day, from: comeDate) ?? 0
        Log.info("Time past: \(pastDay)")
    }

    private func setupData() {
        totalDayLabel.text = "总共待：\(totalDay)天"
        pastDayLabel.text = "已经待：\(pastDay)天"
        remainDayLabel.text = "剩余待：\(remainDay)天"
        let progress = CGFloat(pastDay) / CGFloat(totalDay)
        DispatchQueue.main.async {
            self.progressRing.startProgress(to: progress * 100, duration: 1)
        }
        let currentDate = DateInRegion(Date(), region: .current)
        let fourDollarComeDate = "2024-12-25".toDate() ?? DateInRegion(Date(), region: .current)
        let remainDay = fourDollarComeDate.difference(in: .day, from: currentDate) ?? 0
        fourDollarDayLabel.text = "距离李思源来广州还有：\(remainDay)天"
    }
}

// MARK: - UI

extension DateProgressVC {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews([progressRing, totalDayLabel, pastDayLabel, remainDayLabel, fourDollarDayLabel, jumpBtn, datePicker])
        progressRing.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 250, height: 250))
        }
        totalDayLabel.snp.makeConstraints { make in
            make.top.equalTo(progressRing.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        pastDayLabel.snp.makeConstraints { make in
            make.top.equalTo(totalDayLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        remainDayLabel.snp.makeConstraints { make in
            make.top.equalTo(pastDayLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        fourDollarDayLabel.snp.makeConstraints { make in
            make.top.equalTo(remainDayLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        jumpBtn.snp.makeConstraints { make in
            make.top.equalTo(fourDollarDayLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 50))
        }
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(jumpBtn.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
    }
}
