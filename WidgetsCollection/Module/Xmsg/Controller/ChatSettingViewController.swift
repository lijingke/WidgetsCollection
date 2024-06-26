//
//  ChatSettingViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/31.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class ChatSettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        return view
    }()
}

extension ChatSettingViewController: ChatFilterEventProtocol {
    func resetInput() {}

    func confirmAction() {}
}
