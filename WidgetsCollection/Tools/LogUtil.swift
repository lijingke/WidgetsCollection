//
//  LogUtil.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation

public class LogUtil: NSObject {
    static var Log_Level = 1
    /// 打印日志
    public static func log(_ info: String?) {
        if LogUtil.Log_Level == 1 {
            print("=Log========>\(info ?? "null")")
        }
    }
}
