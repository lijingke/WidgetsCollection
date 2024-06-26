//
//  CollectionLabelHeadView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/22.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class CollectionLabelHeadView: UICollectionReusableView {
    static let reuseID = "headView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurationUI()
    }

    fileprivate func configurationUI() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
