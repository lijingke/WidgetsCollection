//
//  NSObject+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }

    // 用于获取 cell 的 reuse identifier
    class var identifier: String {
        return String(format: "%@_identifier", nameOfClass)
    }
}
