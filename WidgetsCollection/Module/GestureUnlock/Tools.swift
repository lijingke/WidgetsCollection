//
//  Tools.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/3.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

class Tools: NSObject {
    
    // MARK: - 将数组转换成字符串
    static func passwordString(array: NSArray) -> String {
        var str = ""
        for p in array {
            str.append(String(describing: p))
        }
        return str
    }
}
