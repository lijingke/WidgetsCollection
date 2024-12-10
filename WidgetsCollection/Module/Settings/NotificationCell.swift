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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var switchView: UISwitch = {
        let v = UISwitch()
        v.isOn = false
        v.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return v
    }()
}

extension NotificationCell {
    
    @objc func switchChanged(_ sender: UISwitch) {
        let openUrl = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.open(openUrl!, options: [:]) { _ in
            Log.info("Finish")
        }
    }
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
    
    func configData() {
        LocalNotifications.requestPermission(strategy: .askSystemPermissionIfNeeded) { [weak self] success in
            DispatchQueue.main.async {
                self?.switchView.setOn(success, animated: false)
            }
        }
    }
}
