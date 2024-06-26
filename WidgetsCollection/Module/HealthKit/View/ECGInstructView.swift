//
//  ECGInstructView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import UIKit

protocol ECGInstructViewDelegate: NSObjectProtocol {
    func getEcgData()
}

class ECGInstructView: UIView {
    // MARK: Property

    weak var delegate: ECGInstructViewDelegate?

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

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var ecgOperateImage: UIImageView = {
        let view = UIImageView()
        view.image = R.image.ecg_Instruct()
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How to Take an ECG"
        label.font = UIFont.semibold(30)
        label.textColor = UIColor(hexString: "#2A2B2F")
        return label
    }()

    lazy var InstructLabel: UILabel = {
        let label = UILabel()
        label.text = "Recording an ECG typically takes 30 seconds."
        label.font = UIFont.regular(16)
        label.textColor = UIColor(hexString: "#2A2B2F")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    lazy var stepOneView: ECGOperateStepView = {
        let view = ECGOperateStepView()
        view.setupData(imageName: "ECG_Logo", des: "First, open the ECG app on your Apple Watch.")
        return view
    }()

    lazy var stepTwoView: ECGOperateStepView = {
        let view = ECGOperateStepView()
        view.setupData(imageName: "ECG_Watch", des: "Rest your arms on a table or in your lap, and hold your finger on the Digital Crown.")
        return view
    }()

    lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(14)
        label.textColor = UIColor(hexString: "#8A8A8E")
        let content = "Note: To take an accurate ECG, your Apple Watch needs to be snug on the wrist you selected inSettings"
        let attContent = NSMutableAttributedString(string: content)
        let firstRange = content.exMatchStrNSRange(matchStr: "Note: ")
        attContent.addAttributes([.font: UIFont.semibold(14)!], range: firstRange.first!)
        label.attributedText = attContent
        label.numberOfLines = 0
        return label
    }()

    lazy var warnLabel: UILabel = {
        let label = UILabel()
        label.text = "After the test is complete, open R Plus Health and click the button below to get the ECG data."
        label.font = UIFont.regular(14)
        label.textColor = UIColor(hexString: "#FF6770")
        label.numberOfLines = 0
        return label
    }()

    lazy var getDataBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(hexString: "#FF6770")
        btn.setTitle("Get data from App Watch", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.regular(16)
        btn.layer.cornerRadius = 24
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return btn
    }()
}

// MARK: - Event

extension ECGInstructView {
    @objc func btnAction() {
        delegate?.getEcgData()
    }
}

// MARK: - UI

extension ECGInstructView {
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([ecgOperateImage, titleLabel, InstructLabel, stepOneView, stepTwoView, noteLabel, warnLabel, getDataBtn])
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        ecgOperateImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(ecgOperateImage.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        InstructLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(55)
            make.right.equalToSuperview().offset(-55)
            make.centerX.equalToSuperview()
        }
        stepOneView.snp.makeConstraints { make in
            make.top.equalTo(InstructLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        stepTwoView.snp.makeConstraints { make in
            make.top.equalTo(stepOneView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(stepTwoView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-16)
        }
        warnLabel.snp.makeConstraints { make in
            make.top.equalTo(noteLabel.snp.bottom).offset(16)
            make.left.right.equalTo(noteLabel)
        }
        getDataBtn.snp.makeConstraints { make in
            make.top.equalTo(warnLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
