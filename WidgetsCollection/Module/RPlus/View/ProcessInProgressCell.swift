//
//  ProcessInProgressCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/11.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation

class ProcessInProgressCell: UITableViewCell {
    // MARK: Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lazy Get

    lazy var statusIcon = UIImageView(image: R.image.processInProgress())

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold(20)
        label.textColor = UIColor(hexString: "#2A2B2F")
        return label
    }()

    lazy var statusBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.regular(14)
        btn.setTitleColor(UIColor(hexString: "#FF6770"), for: .normal)
        btn.setImage(R.image.processWait(), for: .normal)
        btn.isEnabled = false
        return btn
    }()
}

// MARK: - Data

extension ProcessInProgressCell {
    public func setupData(title: String?, hint: String?) {
        titleLabel.text = title
        statusBtn.isHidden = hint == nil
        if let hintText = hint {
            statusBtn.setTitle(" " + hintText, for: .normal)
        }
    }
}

// MARK: - UI

extension ProcessInProgressCell {
    private func setupUI() {
        contentView.addSubviews([statusIcon, titleLabel, statusBtn])
        statusIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-5)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(statusIcon.snp.right).offset(18)
            make.centerY.equalToSuperview()
        }
        statusBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
}
