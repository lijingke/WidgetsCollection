//
//  TabbarController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class TabbarController: SuperTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setupChildrenViewControllers() {
        
        let btn = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(backAction))

        let oneVC = TabbarSubViewController()
        oneVC.navigationItem.leftBarButtonItem = btn
        
        let twoVC = TabbarSubViewController()
        twoVC.navigationItem.leftBarButtonItem = btn
        
        addChileViewController(title: "One", image: "tab_me_normal", selectedImage: "", controller: oneVC)
        addChileViewController(title: "Two", image: "tab_work_normal", selectedImage: "", controller: twoVC)
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
}
