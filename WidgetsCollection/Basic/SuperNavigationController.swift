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
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundImage = UIImage(color: .white)
        appearance.shadowImage = UIImage(color: .white)
        appearance.backgroundEffect = nil
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
}
