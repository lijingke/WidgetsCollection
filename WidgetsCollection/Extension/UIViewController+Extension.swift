//
//  UIViewController + Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/7.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit
import SwiftUI

extension UIViewController {
    func getVCFromString(_ name: String) -> UIViewController? {
        let className = projectName + "." + name

        if let type = NSClassFromString(className) as? UIViewController.Type {
            return type.init()
        } else {
            return nil
        }
    }

    func getVCClassFromString(_ name: String) -> UIViewController.Type? {
        let className = projectName + "." + name

        if let type = NSClassFromString(className) as? UIViewController.Type {
            return type
        } else {
            return nil
        }
    }
    
}

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}
