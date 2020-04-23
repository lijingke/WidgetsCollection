//
//  SuperTabbarController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

class SuperTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupChildrenViewControllers()
    }
    
    func setupChildrenViewControllers() {
        
    }
    
    func addChileViewController(title: String, image: String, selectedImage: String, controller: UIViewController) {
        
        controller.title = title
        controller.view.backgroundColor = .white
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(named: image) ?? UIImage(systemName: image)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage) ?? UIImage(systemName: selectedImage)
        
        let naviController = SuperNavigationController(rootViewController: controller)
        addChild(naviController)
    }
}
