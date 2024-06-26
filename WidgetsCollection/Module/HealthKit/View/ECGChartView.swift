//
//  ECGChartView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import UIKit

class ECGChartView: UIView {
    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lazy Get

    lazy var classificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#2A2B2F")
        label.font = UIFont.semibold(20)
        return label
    }()

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#9599A8")
        label.font = UIFont.regular(12)
        return label
    }()

    lazy var heartRateIcon: UIImageView = {
        let view = UIImageView()
        view.image = R.image.ecg_HeartRate_Icon()
        return view
    }()

    lazy var averageHRLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(14)
        label.textColor = UIColor(hexString: "#2A2B2F")
        return label
    }()

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    lazy var ecgChartView: YOECGChartView = {
        let view = YOECGChartView(frame: CGRect(origin: .zero, size: CGSize(width: kScreenWidth, height: 200)))
        view.standard.voltageUnit = .volt
        view.standard.sampleFrequency = 512
        return view
    }()
}

// MARK: - Data

extension ECGChartView {
    public func refresh(model: ECGModel) {
        classificationLabel.text = model.classificationDes
        timeLabel.text = DateUtil.getDateStr(interval: Double(model.startTimeStamp), format: "MM/dd/yyyy KK:mm aa")
        if let averageHeartRate = model.averageHeartRate {
            averageHRLabel.text = "\(averageHeartRate) BPM Average"
        } else {
            averageHRLabel.text = "-- BPM Average"
        }
        let width = CGFloat(Float(model.ecgData.count) * ecgChartView.standard.onePointWidth)
        var frame = ecgChartView.frame
        frame.size.width = width
        ecgChartView.frame = frame

        ecgChartView.snp.updateConstraints { make in
            make.width.equalTo(width)
        }

        ecgChartView.refreshSubViewFrame()

        ecgChartView.gridView.isShowSecondText = true
        ecgChartView.gridView.startSecond = 0
        ecgChartView.drawStaticECGLine(model.ecgData)
    }
}

// MARK: - UI

extension ECGChartView {
    private func setupUI() {
        backgroundColor = .white
        addSubviews([classificationLabel, timeLabel, scrollView, heartRateIcon, averageHRLabel])
        scrollView.addSubview(ecgChartView)
        classificationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(classificationLabel.snp.bottom).offset(10)
            make.left.equalTo(classificationLabel)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(220)
        }
        ecgChartView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
            make.width.equalTo(0)
        }
        heartRateIcon.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        averageHRLabel.snp.makeConstraints { make in
            make.centerY.equalTo(heartRateIcon)
            make.left.equalTo(heartRateIcon.snp.right).offset(6)
        }
    }
}
