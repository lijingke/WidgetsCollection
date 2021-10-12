//
//  ProcessHintCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/11.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import UIKit

class ProcessHintCell: UITableViewCell {
    
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
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#F6F7F8")
        view.layer.cornerRadius = 8
        return view
    }()
        
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(14)
        label.textColor = UIColor(hexString: "#9699A6")
        label.numberOfLines = 0
        return label
    }()
}

// MARK: - UI
extension ProcessHintCell {
    private func setupUI() {
        contentView.addSubview(backView)
        backView.addSubview(contentLabel)
        backView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
    }
}

// MARK: - Data
extension ProcessHintCell {
    public func setupData(_ hint: String) {
        let hintAttr = NSMutableAttributedString(string: " " + hint)
        let imageAttachment = NSTextAttachment(image: R.image.processTips()!)
        imageAttachment.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
        let imgAttr = NSAttributedString(attachment: imageAttachment)
        hintAttr.insert(imgAttr, at: 0)
        contentLabel.attributedText = hintAttr
    }
}
