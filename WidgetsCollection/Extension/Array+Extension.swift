//
//  Array+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import Foundation

public extension Array {
    /**  字符串数组转字符串  */
    internal func toString(separator: String) -> String {
        let array: [String] = self as! [String]
        let string = array.joined(separator: separator)
        return string
    }

    /// 分页(一维数组转化为二维数组)
    ///
    /// - Parameter limit: 分页条数(二维数组中每个数组的限制个数) 默认为10条
    /// - Returns: 分页后的二维数组
    func to2Dimensions(_ limit: Int? = nil) -> [[String]] {
        var max = 0
        if let limit = limit {
            max = limit
        } else {
            max = 10
        }
        var sortArticleIds: [[String]] = []
        var j = 0
        var count = self.count
        while count > 0 {
            let value = max > count ? count : max
            let subLogArr: [String] = Array(self[j ..< (j + value)]) as! [String]
            sortArticleIds.append(subLogArr)
            count = count - value
            j = j + value
        }
        return sortArticleIds
    }

    /// 获取元素在数组中的下标
    ///
    /// - Parameter compare: 元素
    /// - Returns: 数组中的下标
    func indexObject<T: Equatable>(of compare: T) -> Int? {
        if let result = self as? [T] {
            for (index, value) in result.enumerated() {
                if value == compare {
                    return index
                }
            }
            return nil
        }
        return nil
    }

    /// 祛除数组中重复的元素
    ///
    /// - Example: let newArray = array.filterDuplicates({$0});
    /// - Returns: 祛除数组中重复的元素的新的结果集
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({ filter($0) }).contains(key) {
                result.append(value)
            }
        }
        return result
    }

    /// 数组转json
    func toString() -> String {
        let array = self
        if !JSONSerialization.isValidJSONObject(array) {
//            LogUtil.log("无法解析出JSONString")
            return ""
        }

        let data: NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData
        let JSONString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }

    func toNSMutableArray() -> NSMutableArray {
        let NSMutableArray: NSMutableArray = []
        for item in self {
            NSMutableArray.add(item)
        }
        return NSMutableArray
    }
}

extension Array {
    func array2NSMutableArray() -> NSMutableArray {
        let NSMutableArray: NSMutableArray = []
        for item in self {
            NSMutableArray.add(item)
        }
        return NSMutableArray
    }
}
