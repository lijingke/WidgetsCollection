//
//  ProcessCompletedCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/11.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import UIKit
import sqlcipher

class ProcessCompletedCell: UITableViewCell {
    
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
    lazy var completedIcon = UIImageView(image: R.image.processCompleted())
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(18)
        label.textColor = UIColor(hexString: "#2A2B2F")
        return label
    }()
    
    lazy var modifyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.regular(14)
        btn.setTitleColor(UIColor(hexString: "#9699A6"), for: .normal)
        btn.setImage(R.image.processEdit(), for: .normal)
        btn.setTitle(" 修改", for: .normal)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return btn
    }()
}

// MARK: - Event
extension ProcessCompletedCell {
    @objc func btnAction() {
        print("btnnnnn")
    }
    
}

// MARK: - Data
extension ProcessCompletedCell {
    public func setupData(title: String?, canEdit: Bool) {
        titleLabel.text = title
        modifyBtn.isHidden = !canEdit
    }
}

// MARK: - UI
extension ProcessCompletedCell {
    private func setupUI() {
        contentView.addSubviews([completedIcon, titleLabel, modifyBtn])
        completedIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-5)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(completedIcon.snp.right).offset(18)
            make.centerY.equalToSuperview()
        }
        modifyBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
}
