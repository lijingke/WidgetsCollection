//
//  CollectionLabelFootView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/22.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class CollectionLabelFootView: UICollectionReusableView {
    
    static let reuseID = "footView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurationUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configurationUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

}
