//
//  ECGMeasureResultView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import UIKit

class ECGMeasureResultView: UIView {
    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy Get
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
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
        let view = YOECGChartView(frame: CGRect(origin: .zero, size: CGSize(width: kScreenWidth-20*2-15*2, height: CGFloat(4.0 * params.oneGridSize))), params: params)
        return view
    }()
    
    lazy var horizontalSepraratorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#F0F1F3")
        return line
    }()
    
    lazy var verticalSepraratorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#F0F1F3")
        return line
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 0
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#666973"), for: .normal)
        btn.titleLabel?.font = UIFont.regular(15)
        btn.addTarget(self, action: #selector(btnAction(sender: )), for: .touchUpInside)
        return btn
    }()
    
    lazy var comfirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 1
        btn.setTitle("Comfirm", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#FF6770"), for: .normal)
        btn.titleLabel?.font = UIFont.regular(15)
        btn.addTarget(self, action: #selector(btnAction(sender: )), for: .touchUpInside)
        return btn
    }()
}

// MARK: - Data

extension ECGMeasureResultView {
    @objc private func btnAction(sender: UIButton) {
        removeFromSuperview()
        switch sender.tag {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
}

// MARK: - Data

extension ECGMeasureResultView {
    public func refresh(model: ECGModel) {
        classificationLabel.text = model.classificationDes
        timeLabel.text = DateUtil.getDateStr(interval: model.startTimeStamp, format: "MM/dd/yyyy KK:mm aa")
        if let averageHeartRate = model.averageHeartRate {
            averageHRLabel.text = "\(averageHeartRate) BPM Average"
        } else {
            averageHRLabel.text = "-- BPM Average"
        }
        let width = CGFloat(Float(model.ecgData.count)*ecgChartView.standard.onePointWidth)
        var frame = ecgChartView.frame
        frame.size.width = width
        ecgChartView.frame = frame
        ecgChartView.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
        ecgChartView.refreshSubViewFrame()
        ecgChartView.gridView.isShowSecondText = false
        ecgChartView.gridView.startSecond = 0
        ecgChartView.drawStaticECGLine(model.ecgData)
        
        DispatchQueue.main.async { [weak self] in
            self?.scrollView.flashScrollIndicators()
        }
    }
}

// MARK: - UI

extension ECGMeasureResultView {
    private func setupUI() {
        backgroundColor = UIColor(hexString: "#000000", withAlpha: 0.6)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.width.equalTo(345)
            make.center.equalToSuperview()
        }
        contentView.addSubviews([classificationLabel, timeLabel, separatorLine, heartRateIcon, averageHRLabel, scrollView, horizontalSepraratorLine, cancelBtn, verticalSepraratorLine, comfirmBtn])
        scrollView.addSubview(ecgChartView)
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
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(averageHRLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(4 * ecgChartView.standard.oneGridSize)
        }
        ecgChartView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
            make.width.equalTo(100)
        }
        horizontalSepraratorLine.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        verticalSepraratorLine.snp.makeConstraints { make in
            make.top.equalTo(horizontalSepraratorLine.snp.bottom)
            make.centerX.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 1, height: 50))
        }
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(verticalSepraratorLine)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(verticalSepraratorLine.snp.left)
        }
        comfirmBtn.snp.makeConstraints { make in
            make.top.equalTo(verticalSepraratorLine)
            make.right.bottom.equalToSuperview()
            make.left.equalTo(verticalSepraratorLine.snp.right)
        }
    }
}

