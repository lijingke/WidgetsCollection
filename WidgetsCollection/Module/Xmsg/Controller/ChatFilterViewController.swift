//
//  ChatFilterViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/31.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class ChatFilterViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureData()
  }
  
  fileprivate func configureUI() {
    view.backgroundColor = .white
    view.addSubview(mainView)
    mainView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  func configureData() {
    let tags = ["高血压", "干预服务包", "干预服务包发送助手", "菁蓉大厦卫生室", "提醒"].compactMap { (title) -> tagViewModel? in
      var entity = tagViewModel()
      entity.title = title
      entity.isSelected = false
      return entity
    }
    mainView.configureData(defultTags: tags, customTags: ["Test1", "Test2", "Test3"], customMembers: ["赵", "钱", "孙", "李"])
  }
  
  lazy var mainView: ChatFilterView = {
    let view = ChatFilterView()
    view.delegate = self
    return view
  }()
  
}

extension ChatFilterViewController: ChatFilterEventProtocol{
  
  func confirmAction(choosedDefultTags: [tagViewModel], customMembers: [String], customTags: [String]) {
    let selectTags = choosedDefultTags.compactMap { (item) -> String? in
      return item.title
    }
    print(selectTags)
    print(customMembers)
    print(customTags)
  }
}
