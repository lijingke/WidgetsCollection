//
//  TabbarController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class TabbarController: BaseTabbarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupChildrenViewControllers() {
        let btn = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(backAction))

        let oneVC = TabbarSubViewController()
        oneVC.navigationItem.leftBarButtonItem = btn

        let twoVC = TabbarSubViewController()
        twoVC.navigationItem.leftBarButtonItem = btn

        addChileViewController(title: "One", image: "tab_me_normal", selectedImage: "tab_me_normal", controller: oneVC)
        addChileViewController(title: "Two", image: "tab_work_normal", selectedImage: "tab_work_normal", controller: twoVC)
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
