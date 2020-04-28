//
//  MainTabbarController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/8.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class MainTabbarController: SuperTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupChildrenViewControllers() {
                        
        addChileViewController(title: "Home", image: "house", selectedImage: "house.fill", controller: HomepageViewController())
        addChileViewController(title: "Setting", image: "square.grid.2x2", selectedImage: "square.grid.2x2.fill", controller: SettingViewController())
        
    }
    
}
