//
//  ECGMeasureListCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import UIKit

class ECGMeasureListCell: UITableViewCell {
    // MARK: Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
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
    
    lazy var separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#F0F1F3")
        return line
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
        let params = YOECGParamter()
        params.voltageUnit = .volt
        params.sampleFrequency = 512
        params.positiveNum = 2
        params.negativeNum = 2
        let view = YOECGChartView(frame: CGRect(origin: .zero, size: CGSize(width: kScreenWidth-20*2-15*2, height: 100)), params: params)
        view.clipsToBounds = true
        return view
    }()
}

// MARK: - Data

extension ECGMeasureListCell {
    public func refresh(model: ECGModel) {
        
        classificationLabel.text = model.classificationDes
        timeLabel.text = DateUtil.getDateStr(interval: model.startTimeStamp, format: "MM/dd/yyyy KK:mm aa")
        if let averageHeartRate = model.averageHeartRate {
            averageHRLabel.text = "\(averageHeartRate) BPM Average"
        } else {
            averageHRLabel.text = "-- BPM Average"
        }
        let subVoltArr = Array(ArraySlice(model.ecgData[0..<512*3]) )
        let width = CGFloat(Float(subVoltArr.count) * ecgChartView.standard.onePointWidth)
        var frame = ecgChartView.frame
        frame.size.width = width
        ecgChartView.frame = frame
        
        ecgChartView.refreshSubViewFrame()
        ecgChartView.gridView.isShowSecondText = false
        ecgChartView.gridView.startSecond = 0
        ecgChartView.drawStaticECGLine(subVoltArr)
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - UI

extension ECGMeasureListCell {
    private func setupUI() {
        backgroundColor = .white
        contentView.addSubviews([classificationLabel, timeLabel, separatorLine, heartRateIcon, averageHRLabel, ecgChartView])
        classificationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(classificationLabel)
            make.right.equalToSuperview().offset(-15)
        }
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(classificationLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        heartRateIcon.snp.makeConstraints { make in
            make.centerY.equalTo(averageHRLabel)
            make.left.equalToSuperview().offset(15)
        }
        averageHRLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(15)
            make.left.equalTo(heartRateIcon.snp.right).offset(6)
        }
        ecgChartView.snp.makeConstraints { make in
            make.top.equalTo(averageHRLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(100)
        }
    }
}

