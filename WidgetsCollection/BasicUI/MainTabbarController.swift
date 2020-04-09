//
//  MainTabbarController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/8.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupChildrenViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupChildrenViewControllers() {
        
        addChileViewController(title: "One", image: "tab_me_normal", selectedImage: "", controller: TabbarSubViewController())
        addChileViewController(title: "Two", image: "tab_work_normal", selectedImage: "", controller: TabbarSubViewController())
    }
    
    fileprivate func addChileViewController(title: String, image: String, selectedImage: String, controller: UIViewController) {
        
        controller.title = title
        
        controller.view.backgroundColor = .white
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(named: image)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(backAction))
        
        let btn = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(backAction))
        
        controller.navigationItem.leftBarButtonItem = btn
        
        let naviController = UINavigationController(rootViewController: controller)
                
        addChild(naviController)
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
