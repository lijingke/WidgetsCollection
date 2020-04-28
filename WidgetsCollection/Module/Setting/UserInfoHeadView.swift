//
//  UserInfoHeadView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class UserInfoHeadView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var userAvator: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "cat")
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "未填写"
        label.textColor = UIColor(hex: 0x0C1832)
        label.font = UIFont.semibold(20)
        return label
    }()
    
    lazy var userMailLabel: UILabel = {
        let label = UILabel()
        label.text = "未填写"
        label.textColor = UIColor(hex: 0x0C1832)
        label.font = UIFont.regular(18)
        return label
    }()
    
}

extension UserInfoHeadView {
    private func setupUI() {
        
        addSubview(userAvator)
        addSubview(userNameLabel)
        addSubview(userMailLabel)

        userAvator.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.bottom.equalToSuperview().offset(-20)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userAvator)
            make.left.equalTo(userAvator.snp.right).offset(28)
        }
        
        userMailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userNameLabel)
            make.bottom.equalTo(userAvator)
        }
        
    }
    
    public func setupData(_ model: UserInfoModel?) {
        userNameLabel.text = model?.username
        userMailLabel.text = model?.email
    }
}
