//
//  ProcessUncompletedCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/11.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation

class ProcessUncompletedCell: UITableViewCell {
    
    // MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy Get
    lazy var unCompletedIcon = UIImageView(image: R.image.processIncomplete())
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(16)
        label.textColor = UIColor(hexString: "#9699A6")
        return label
    }()
}

// MARK: - Data
extension ProcessUncompletedCell {
    public func setupData(title: String?) {
        titleLabel.text = title
    }
}

// MARK: - UI
extension ProcessUncompletedCell {
    private func setupUI() {
        contentView.addSubviews([unCompletedIcon, titleLabel])
        unCompletedIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-5)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(unCompletedIcon.snp.right).offset(18)
            make.centerY.equalToSuperview()
        }
    }
}
