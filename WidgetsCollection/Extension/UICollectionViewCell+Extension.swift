//
//  UICollectionViewCell+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/22.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    public static var identifier: String {
        return NSStringFromClass(self as AnyClass).components(separatedBy: ".").last ?? "UITableViewCell"
    }
    
    public static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}

