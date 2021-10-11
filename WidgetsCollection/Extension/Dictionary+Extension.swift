//
//  Dictionary+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import UIKit

extension Dictionary {
    /// 获取字符串值
    func strValue(_ key: Key)->String {
        return self[key] as? String ?? ""
    }
    
    /// 获取Int值
    func intValue(_ key: Key)->Int {
        if let va = self[key] {
            return "\(va)".intValue()
        }
        return 0
    }
    
    /// 获取字典
    func dictionary(_ key: Key)->[String: Any] {
        let dic = self[key] as? [String: Any] ?? [:]
        return dic
    }
    
    /// 数组
    func array(_ key: Key)->[[String: Any]] {
        let array = self[key] as? [[String: Any]] ?? []
        return array
    }
    
    /// 获取Double值
    func doubleValue(_ key: Key)->Double {
        if let va = self[key] {
            return "\(va)".toDouble()
        }
        return 0
    }
}
