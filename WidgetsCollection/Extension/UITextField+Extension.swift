//
//  UITextField+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/9/2.
//

import Foundation
import UIKit

extension UITextField {
    // MARK: - 设置暂位文字的颜色

    var placeholderColor: UIColor {
        get {
            let color = value(forKeyPath: "_placeholderLabel.textColor")
            if color == nil {
                return UIColor.white
            }
            return color as! UIColor
        }

        set {
            setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
    }

    // MARK: - 设置暂位文字的字体

    var placeholderFont: UIFont {
        get {
            let font = value(forKeyPath: "_placeholderLabel.font")
            if font == nil {
                return UIFont.systemFont(ofSize: 14)
            }
            return font as! UIFont
        }

        set {
            setValue(newValue, forKeyPath: "_placeholderLabel.font")
        }
    }
}
