//
//  UIColor+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0xFF00) >> 8
        let b = hex & 0xFF
        self.init(red: CGFloat(r) / 0xFF,
                  green: CGFloat(g) / 0xFF,
                  blue: CGFloat(b) / 0xFF,
                  alpha: alpha)
    }

    static func rgb(hex: UInt32, alpha: CGFloat? = 1.0) -> UIColor {
        return UIColor(hex: hex, alpha: alpha ?? 1.0)
    }
}

extension UIColor {
    class func hexStringToColor(hexString: String) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("0X") {
            cString = String(cString.suffix(6))
        }
        if cString.hasPrefix("#") {
            cString = String(cString.suffix(6))
        }
        if cString.count != 6 {
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
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)

        return UIColor(displayP3Red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}

extension UIColor {
    // Hex String -> UIColor
    convenience init(hexString: String, withAlpha: CGFloat = 1.0) {
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: withAlpha)
    }

    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    /// 根据进度值修改颜色
    /// - Parameters:
    ///   - progress: 进度值，范围0-1
    ///   - startColor: 进度为0时的初始色，默认白色
    ///   - endColor: 进度为1时的结束色，默认黑色
    /// - Returns: 返回的颜色，可能为空
    static func progressColor(forProgress progress: CGFloat, startColor: String? = nil, endColor: String? = nil) -> UIColor? {
        
        let startColor = UIColor(hexString: startColor ?? "#FFFFFF")
        let endColor = UIColor(hexString: endColor ?? "#000000")
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let startComponents = startColor.cgColor.components ?? []
        let endComponents = endColor.cgColor.components ?? []

        var components: [CGFloat] = []
        for (index, startComponent) in startComponents.enumerated() {
            let endComponent = endComponents[index]
            let component = (endComponent - startComponent) * progress + startComponent
            components.append(component)
        }
        if let cgColor = CGColor(colorSpace: colorSpace, components: components) {
            return UIColor(cgColor: cgColor)
        }

        return nil
    }

    static var random: UIColor {
        let red = CGFloat(arc4random_uniform(255) + 1) / 255
        let green = CGFloat(arc4random_uniform(255) + 1) / 255
        let blue = CGFloat(arc4random_uniform(255) + 1) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    static var themeColor: UIColor {
        return UIColor(hexString: "#0EA0A0")
    }
}

#if os(iOS)
    extension NSObject {
        func colorWithGradient(frame: CGRect, colors: [UIColor]) -> UIColor {
            // create the background layer that will hold the gradient
            let backgroundGradientLayer = CAGradientLayer()
            backgroundGradientLayer.frame = frame

            // we create an array of CG colors from out UIColor array
            let cgColors = colors.map { $0.cgColor }

            backgroundGradientLayer.colors = cgColors
            // 下面两个参数是：开始点，结尾点；两点之间的连线可以形成一个矢量方向，即是渐变的方向
            backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0) // 左上角
            backgroundGradientLayer.endPoint = CGPoint(x: 1, y: 0) // 右上角
            UIGraphicsBeginImageContext(backgroundGradientLayer.bounds.size)
            backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return UIColor(patternImage: backgroundColorImage!)
        }
    }
#endif
