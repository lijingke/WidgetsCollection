//
//  SuperNavigationController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class SuperNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
}
