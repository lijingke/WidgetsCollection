//
//  BaseTabbarController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation
import UIKit

class BaseTabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildrenViewControllers()
    }

    func setupChildrenViewControllers() {}

    func addChileViewController(title: String, image: String, selectedImage: String, controller: UIViewController) {
        controller.title = title
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(named: image) ?? UIImage(systemName: image)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage) ?? UIImage(systemName: selectedImage)

        let naviController = BaseNavigationController(rootViewController: controller)
        addChild(naviController)
    }
}
