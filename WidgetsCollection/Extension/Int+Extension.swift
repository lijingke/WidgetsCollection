//
//  Int+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/28.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

extension Int {
    var boolValue: Bool {
        return self != 0
    }
}

extension Int {
    func secondsToTimeStringWithoutDay() -> String {
        // 小时计算
        let hours = self/3600
        
        // 分钟计算
        let minutes = self%3600/60
        
        // 秒计算
        let second = self%60
        
        let timeString = String(format: "%02lu:%02lu:%02lu", hours, minutes, second)
        return timeString
    }
    
    /// 秒数转化为时间字符串
    func secondsToTimeString() -> String {
        // 天数计算
        let days = self/(24*3600)
    
        // 小时计算
        let hours = self%(24*3600)/3600
    
        // 分钟计算
        let minutes = self%3600/60
    
        // 秒计算
        let second = self%60
    
        let timeString = String(format: "%lu天 %02lu:%02lu:%02lu", days, hours, minutes, second)
        return timeString
    }
  
    func secondsToChsString() -> String {
        var timeString = ""
        // 天数计算
        let days = self/(24*3600)
    
        // 小时计算
        let hours = self%(24*3600)/3600
    
        // 分钟计算
        let minutes = self%3600/60
    
        // 秒计算
        let second = self%60
    
        if days > 0 {
            timeString.append("\(days)天")
        }
    
        if hours > 0 {
            timeString.append("\(hours)时")
        }
    
        if minutes > 0 {
            timeString.append("\(minutes)分")
        }
    
        if second > 0 {
            if second < 10 {
                timeString.append("0\(second)秒")
            } else {
                timeString.append("\(second)秒")
            }
        } else {
            timeString.append("00秒")
        }
    
        return timeString
    }
}

extension Int {
    func toChsString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style(rawValue: UInt(CFNumberFormatterRoundingMode.roundHalfDown.rawValue))!
        let string: String = formatter.string(from: NSNumber(value: self))!
        return string
    }
}
