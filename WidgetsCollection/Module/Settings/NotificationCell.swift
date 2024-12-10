//
//  NotificationCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/10.
//

import Foundation
import UIKit

class NotificationCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var switchView: UISwitch = {
        let v = UISwitch()
        return v
    }()
    
}

extension NotificationCell {
    private func setupUI() {
        textLabel?.text = "通知"
        accessoryType = .none
        imageView?.image = UIImage(systemName: "app.badge")
        
        contentView.addSubviews([switchView])
        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
}
