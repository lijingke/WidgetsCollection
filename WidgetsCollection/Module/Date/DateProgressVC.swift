//
//  DateProgressVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/9.
//

import Foundation
import SnapKit
import SwiftDate
import UIKit

class DateProgressVC: BaseViewController {
    // MARK: Property

    private var totalDay: Int = 0
    private var pastDay: Int = 0
    private var remainDay: Int = 0
    private var fourDollarConstranit: Constraint?
    private var isShowFourDollar: Bool = false
    private var notiGroup: LocalNotificationsGroup?
    private var currentDate = DateInRegion(Date(), region: .current) {
        didSet {
            initData()
            refreshUI()
        }
    }

    let menuArr: [PopMenu] = [
        PopMenu(title: "打开通知", icon: "app.badge"),
        PopMenu(title: "取消通知", icon: "eraser")
    ]

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
        refreshUI()
    }

    override func getNavigatorConfig() -> NavigatorConfig? {
        return NavigatorConfig.newConfig().isTranslucent(true).rightBarButton(image: UIImage(systemName: "bell"), action: #selector(notiAction))
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

    lazy var menuView: PopMenuView = {
        let menu = PopMenuView(dataArray: menuArr, origin: CGPoint(x: kScreenWidth - 13, y: 90), size: CGSize(width: 130, height: 44), direction: PopMenueDirection.right)
        menu.delegate = self
        return menu
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

    lazy var fourDollarView: FourDollarView = {
        let view = FourDollarView()
        view.updateBlock = { [weak self] in
            self?.fourDollarTimeAction()
        }
        view.clipsToBounds = true
        return view
    }()

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        return picker
    }()
}

// MARK: - PopMenuViewDelegate

extension DateProgressVC: PopMenuViewDelegate {
    func PopMenuViewDidSelectedAt(index: Int) {
        menuView.dismiss()
        if index == 0 {
            addNoti()
        } else {
            removeAllNoti()
        }
    }
}

// MARK: - Noti

extension DateProgressVC {
    func addNoti() {
        notiGroup = LocalNotifications.schedule(permissionStrategy: .askSystemPermissionIfNeeded) {
            EveryDay(forDays: 30, starting: .today)
                .at(hour: 8, minute: 0, second: 0)
                .schedule(with: content(forTriggerDate:))
            EveryDay(forDays: 30, starting: .today)
                .at(hour: 9, minute: 0, second: 0)
                .schedule(with: content(forTriggerDate:))
            EveryDay(forDays: 30, starting: .today)
                .at(hour: 18, minute: 00, second: 0)
                .schedule(with: content(forTriggerDate:))
            EveryDay(forDays: 30, starting: .today)
                .at(hour: 19, minute: 00, second: 0)
                .schedule(with: content(forTriggerDate:))
        }
    }

    func removeAllNoti() {
        if let group = notiGroup {
            LocalNotifications.remove(group: group)
        }
    }

    func content(forTriggerDate date: Date) -> NotificationContent {
        // create content based on date
        let content = NotificationContent()
        content.title = "回成都倒计时"
        let progress = CGFloat(pastDay) / CGFloat(totalDay)
        content.subtitle = "已过去\(pastDay)天：\((progress * 100).roundToStr2(2))%"
        content.body = "还剩\(remainDay)天"
        content.sound = .default
        return content
    }
}

// MARK: - Event

extension DateProgressVC {
    @objc func notiAction() {
        menuView.pop()
    }

    private func fourDollarTimeAction() {
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
            self.currentDate = DateInRegion(datePicker.date, region: .current)
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

    @objc private func showFourDollar() {
        isShowFourDollar.toggle()
        if isShowFourDollar {
            fourDollarConstranit?.deactivate()
        } else {
            fourDollarConstranit?.activate()
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
        if currentDate > comeDate {
            pastDay = currentDate.difference(in: .day, from: comeDate) ?? 0
            if currentDate > goDate {
                remainDay = 0
            } else {
                remainDay = goDate.difference(in: .day, from: currentDate) ?? 0
            }
        } else {
            pastDay = 0
            remainDay = goDate.difference(in: .day, from: comeDate) ?? 0
        }

        totalDay = goDate.difference(in: .day, from: comeDate) ?? 0
        Log.info("Time past: \(pastDay)")
    }

    private func refreshUI() {
        totalDayLabel.text = "总共待：\(totalDay)天"
        pastDayLabel.text = "已经待：\(pastDay)天"
        remainDayLabel.text = "剩余待：\(remainDay)天"
        let progress = CGFloat(pastDay) / CGFloat(totalDay)
        DispatchQueue.main.async {
            self.progressRing.startProgress(to: progress * 100, duration: 1)
        }

        let fourDollarComeDate = "2024-12-25".toDate() ?? DateInRegion(Date(), region: .current)
        var fourDollarComeRemainDay = 0
        if currentDate > fourDollarComeDate {
            fourDollarComeRemainDay = 0
        } else {
            fourDollarComeRemainDay = fourDollarComeDate.difference(in: .day, from: currentDate) ?? 0
        }
        fourDollarView.setupContent("距离李思源来广州还有：\(fourDollarComeRemainDay)天")
    }
}

// MARK: - UI

extension DateProgressVC {
    private func setupUI() {
        view.backgroundColor = .white
        let tapGes = UITapGestureRecognizer()
        tapGes.numberOfTapsRequired = 2
        tapGes.addTarget(self, action: #selector(showFourDollar))
        view.addGestureRecognizer(tapGes)
        view.addSubviews([progressRing, totalDayLabel, pastDayLabel, remainDayLabel, fourDollarView, datePicker])
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
        fourDollarView.snp.makeConstraints { make in
            make.top.equalTo(remainDayLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            fourDollarConstranit = make.height.equalTo(0).constraint
        }
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(fourDollarView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
    }
}
