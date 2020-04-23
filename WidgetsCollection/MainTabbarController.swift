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
        self.view.backgroundColor = .white
    }
    
    override func setupChildrenViewControllers() {
                        
        addChileViewController(title: "One", image: "tab_me_normal", selectedImage: "", controller: HomepageViewController())
        addChileViewController(title: "Two", image: "tab_work_normal", selectedImage: "", controller: TabbarSubViewController())
        
    }
    
}
