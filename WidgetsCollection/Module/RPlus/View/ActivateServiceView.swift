//
//  ActivateServiceView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/9.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import UIKit

class ActivateServiceView: UIView {
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

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "激活服务"
        label.textColor = UIColor(hexString: "#2A2B2F")
        label.font = UIFont.regular(32)
        return label
    }()

    lazy var inputField: UITextField = {
        let field = UITextField()
        field.placeholder = "请输入服务激活码"
        field.font = UIFont.regular(18)
        field.backgroundColor = UIColor(hexString: "#F6F7F8")
        field.layer.cornerRadius = 28
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 0))
        field.leftViewMode = .always
        return field
    }()

    lazy var bottomLabel: UILabel = {
        let label = UILabel()

        return label
    }()
}

extension ActivateServiceView {
    private func setupUI() {
        addSubviews([titleLabel, inputField])
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(41)
            make.centerX.equalToSuperview()
        }
        inputField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(38)
            make.right.equalToSuperview().offset(-38)
            make.height.equalTo(56)
        }
    }
}
