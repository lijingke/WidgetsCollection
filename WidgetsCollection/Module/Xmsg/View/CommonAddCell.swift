//
//  CommonAddCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/31.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class CommonAddCell: UITableViewCell {
    static var reuseId = "CommonAddCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configureUI() {
        addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
    }

    lazy var addBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("  添加", for: .normal)
        btn.titleLabel?.font = UIFont.regular(17)
        btn.setTitleColor(UIColor(hex: 0x3292FF), for: .normal)
        btn.setImage(UIImage(named: "member_add"), for: .normal)
        btn.isUserInteractionEnabled = false
        return btn
    }()
}
