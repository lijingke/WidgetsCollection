//
//  CommonInputCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/31.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class CommonInputCell: UITableViewCell {
  
  static let reuseId = "CommonInputCell"
  
  public var inputBlock: ((String)->())?
  
  public var placeHolder: String? {
    didSet {
      inputField.placeholder = placeHolder
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func configureUI() {
    addSubview(inputField)
    inputField.snp.makeConstraints { (make) in
      make.top.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(15)
      make.right.equalToSuperview().offset(-15)
      make.height.equalTo(60)
    }
  }
  
  lazy var inputField: UITextField = {
    let field = UITextField()
    field.placeholder = "请输入"
    field.delegate = self
    field.returnKeyType = .done
    return field
  }()
  
}

extension CommonInputCell: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let inputText = textField.text {
      inputBlock?(inputText)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    inputField.resignFirstResponder()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string == " " {
      return false
    }
    return true
  }
  
}
