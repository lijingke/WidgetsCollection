//
//  FilterViewHeadCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/1/2.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class FilterViewHeadCell: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func configureUI() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().offset(15)
    }
  }
  
  public func setTitle(_ title: String) {
    titleLabel.text = title
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.medium(17)
    label.textColor = UIColor(hex: 0x000000)
    return label
  }()
  
}
