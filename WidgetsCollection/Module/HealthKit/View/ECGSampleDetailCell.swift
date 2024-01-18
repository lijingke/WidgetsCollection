//
//  ECGSampleDetailCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation

class ECGSampleDetailCell: UITableViewCell {
    // MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy Get
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#9599A8")
        label.font = UIFont.regular(12)
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#2A2B2F")
        label.font = UIFont.regular(14)
        return label
    }()
}

// MARK: - Data
extension ECGSampleDetailCell {
    public func setup(title: String?, detail: String?) {
        titleLabel.text = title
        detailLabel.text = detail
    }
}

// MARK: - UI
extension ECGSampleDetailCell {
    private func setupUI() {
        contentView.addSubviews([titleLabel, detailLabel])
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
        }
    }
}
