//
//  UIFont+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

public extension UIFont {
    static func medium(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: fontSize)
    }

    static func regular(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Regular", size: fontSize)
    }

    static func semibold(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize)
    }

    static func light(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Light", size: fontSize)
    }

    static func bold(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: fontSize)
    }
}
