//
//  MainTabbarController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/3.
//

import Foundation

class MainTabbarController: SuperTabbarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupChildrenViewControllers() {
        addChileViewController(title: "Home", image: "house", selectedImage: "house.fill", controller: HomeViewController())
        addChileViewController(title: "Setting", image: "square.grid.2x2", selectedImage: "square.grid.2x2.fill", controller: SettingViewController())
    }
}
