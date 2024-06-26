//
//  ChatFilterTagCollectionCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/1/2.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class ChatFilterTagCollectionCell: UICollectionViewCell {
    static let reuseId = "ChatFilterTagCollectionCell"

    var data: tagViewModel? {
        didSet {
            tagBtn.isSelected = data?.isSelected ?? false
            tagBtn.setTitle(data?.title, for: .normal)
            if tagBtn.isSelected {
                tagBtn.layer.borderColor = UIColor.white.cgColor
            } else {
                tagBtn.layer.borderColor = UIColor.black.cgColor
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configureUI() {
        addSubview(tagBtn)
        tagBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    lazy var tagBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
        btn.setTitleColor(UIColor(hex: 0x3292FF), for: .selected)
        btn.titleLabel?.font = UIFont.regular(14)
        btn.setBackgroundImage(UIImage.getImageWithColor(color: .white), for: .normal)
        btn.setBackgroundImage(UIImage.getImageWithColor(color: UIColor(hex: 0x3292FF, alpha: 0.1)), for: .selected)
        btn.isUserInteractionEnabled = false
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor(hex: 0xABABAB).cgColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
}
