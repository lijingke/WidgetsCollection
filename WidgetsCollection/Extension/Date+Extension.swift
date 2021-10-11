//
//  Date+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/8/22.
//

import Foundation

fileprivate let dateFormatter: DateFormatter = {
    let dateFmt = DateFormatter()
    dateFmt.timeZone = TimeZone.current
    return dateFmt
}()

extension Date {
    func toString(_ format: String? = "yyyy-MM-dd") -> String {
        if let fmt = format {
            dateFormatter.dateFormat = fmt
        }
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toTimeStamp(_ format: String? = "yyyy-MM-dd") -> TimeInterval {
        if let fmt = format {
            dateFormatter.dateFormat = fmt
        }
        let date: Date = dateFormatter.date(from: self) ?? Date()
        return date.timeIntervalSince1970
    }
    
    public func substringToIndex(_ index: Int) -> String {
        let startIndex = self.startIndex
        let endIndex = self.index(startIndex, offsetBy: index)
        let subStr = self[startIndex..<endIndex]
        return String(subStr)
    }
}

extension Int {
    public func toTimeString(_ format: String? = "yyyy-MM-dd") -> String {
        let timeInterval = TimeInterval(self)
        return Date(timeIntervalSince1970: timeInterval).toString(format)
    }
}

extension Int64 {
    
    public func toDate(_ format: String? = "yyyy-MM-dd") -> Date {
        let timeInterval = TimeInterval(self / 1000)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    public func toDateString(_ format: String? = "yyyy-MM-dd") -> String {
        return toDate(format).toString(format)
    }
}

