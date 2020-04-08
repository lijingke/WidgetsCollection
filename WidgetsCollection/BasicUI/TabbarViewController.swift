//
//  TabbarViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/8.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupChildrenViewControllers()
    }
    
    private func setupChildrenViewControllers() {
                        
        let one = TabbarSubViewController()
        one.tabBarItem.title = "One"
        one.tabBarItem.image = UIImage(named: "tab_me_normal")
        
        let two = TabbarSubViewController()
        two.tabBarItem.title = "Two"
        two.tabBarItem.image = UIImage(named: "tab_work_normal")
        
        addChild(one)
        addChild(two)
    }
}
