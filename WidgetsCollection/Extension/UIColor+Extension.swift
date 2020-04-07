//
//  UIColor+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0xff00) >> 8
        let b = hex & 0xff
        self.init(red: CGFloat(r) / 0xff,
                  green: CGFloat(g) / 0xff,
                  blue: CGFloat(b) / 0xff,
                  alpha: alpha)
    }
    
    public static func rgb(hex: UInt32, alpha: CGFloat? = 1.0) -> UIColor {
        return UIColor(hex: hex, alpha: alpha ?? 1.0);
    }
    
}

extension UIColor {
    
    class func hexStringToColor(hexString: String) -> UIColor
    {
        
        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6
        {
            return UIColor.black
        }
        if cString.hasPrefix("0X")
        {            
            cString = String(cString.suffix(6))
        }
        if cString.hasPrefix("#")
        {
            cString = String(cString.suffix(6))
        }
        if cString.count != 6
        {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt64 = 0x0
        var g: UInt64 = 0x0
        var b: UInt64 = 0x0
        Scanner.init(string: rString).scanHexInt64(&r)
        Scanner.init(string: gString).scanHexInt64(&g)
        Scanner.init(string: bString).scanHexInt64(&b)
        
        return UIColor(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
    }
    
}
