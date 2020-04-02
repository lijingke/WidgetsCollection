//
//  UIFont+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

extension UIFont {
    
    public static func medium(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: fontSize);
    }
    
    public static func regular(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Regular", size: fontSize);
    }
    
    public static func semibold(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize);
    }
    
    public static func light(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Light", size: fontSize);
    }
    
    public static func bold(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: fontSize);
    }
    
}
