//
//  ECGOperateStepView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import UIKit

class ECGOperateStepView: UIView {
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

    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    lazy var desLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(16)
        label.numberOfLines = 0
        return label
    }()
}

// MARK: - Data

extension ECGOperateStepView {
    public func setupData(imageName: String, des: String) {
        iconView.image = UIImage(named: imageName)
        desLabel.text = des
    }
}

// MARK: - UI

extension ECGOperateStepView {
    private func setupUI() {
        addSubviews([iconView, desLabel])
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-6)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        desLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-42)
        }
    }
}

