//
//  PopMenuViewCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import Foundation
import UIKit

class PopMenuViewCell: UITableViewCell {
    lazy var imgView: UIImageView = .init()
    lazy var titleLabel: UILabel = .init()
    lazy var separtorLine: UIView = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        backgroundColor = UIColor.clear
        contentView.addSubview(imgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(separtorLine)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        imgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(10)
            make.width.equalTo(self.imgView.snp.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.imgView.snp.right)
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(5)
        }
        separtorLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(1)
        }
    }
}

extension PopMenuViewCell {
    public func setupData(_ menu: PopMenu) {
        if let imageName = menu.icon {
            imgView.image = UIImage(named: imageName) ?? UIImage(systemName: imageName)
        } else {
            titleLabel.snp.updateConstraints { make in
                make.left.equalTo(self.imgView.snp.left)
            }
        }
        titleLabel.text = menu.title
    }
}
