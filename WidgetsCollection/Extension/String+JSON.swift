//
//  String+JSON.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import UIKit

extension String {
    /// String 转 字典
    func toDic() -> [String: Any] {
        if count == 0 { return [:] }
        let data = self.data(using: String.Encoding.utf8)
        var tempDic: [String: Any] = [:]
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
            tempDic = dict
        }
        if !tempDic.isEmpty { return tempDic }

        // 狗血的，字符串里的字符串转dic
        guard let dic = try? JSONSerialization.jsonObject(with: self.data(using: .utf8)!, options: .allowFragments) as? [String: Any] ?? [:] else {
            let beginStr = "\"{"
            let endStr = "}\""
            let str = self
            if str.hasPrefix(beginStr), str.hasSuffix(endStr) {
                let subStr = str.getSubString(startIndex: 1, endIndex: str.count - 2)
                guard let vDic = try? JSONSerialization.jsonObject(with: subStr.data(using: .utf8)!, options: .allowFragments) as? [String: Any] ?? [:] else {
                    return [:]
                }
                return vDic
            }

            return [:]
        }
        return dic
    }

    /// 转字符串
    static func toStr(_ contents: [String]) -> String {
        var content = ""
        for item in contents {
            content.append("\(item)\r\n")
        }
        return content
    }

    /// 字典转String
    static func dicToStr(_ dic: [String: Any]) -> String? {
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        if data == nil { return nil }
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }

    /// 转数组
    func toArray() -> NSArray {
        if count == 0 { return [] }
        let jsonData: Data = data(using: .utf8)!

        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return []
    }

    /// 富文本 NSAttributedStringKey.foregroundColor
    func getAttring(_ selfStyles: [NSAttributedString.Key: Any], _ subStrs: [String], _ subStyles: [NSAttributedString.Key: Any]) -> NSAttributedString {
        if count == 0 { return NSAttributedString() }
        let attriString = NSMutableAttributedString(string: self)
        for (k, v) in selfStyles {
            attriString.addAttribute(k, value: v, range: rangeOfStr(subStr: self))
        }
        for subStr in subStrs {
            if !contains(subStr) {
                continue
            }
            let range = rangeOfStr(subStr: subStr)
            for (k, v) in subStyles {
                attriString.addAttribute(k, value: v, range: range)
            }
        }
        return attriString
    }

    /// 自定义转整数
    func intValue() -> Int {
        if count == 0 { return -1 }
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return -1
        }
    }

    /// 逗号拼接 逗号隔开 拼接数组
    func appendStr(_ strs: [String]) -> String {
        if strs.count == 0 { return self }
        var str = self
        if str.hasSuffix(",") {
            str.removeLast()
        }
        if str.hasPrefix(",") {
            str.removeFirst()
        }
        for s in strs {
            if s.count == 0 { continue }
            str = "\(str),\(s)"
        }
        if str.hasPrefix(",") {
            str.removeFirst()
        }
        return str
    }

    /// 移除最后个符号
    func removeLastChart(_ chart: String) -> String {
        var str = self
        if str.hasSuffix(chart) {
            str.removeLast()
        }
        return str
    }

    /// 获取数组（逗号分开）
    func getArr() -> [String] {
        return split(",")
    }

    /// 是否是正整纯数字
    func isNum() -> Bool {
        let regex = "\\d+" // ^-?[0-9]\d*$
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    /** 是否是给定格式的小数或整数
     intNum:整数位数 0则表示整数位不能大于0
     floatNum：小数位数 */
    func isDoubNum2(_ intLen: Int, _ floatLen: Int) -> Bool {
        // 小数部分 21.32
        let doublueRe = "^\\d{1,\(intLen)}\\.\\d{1,\(floatLen)}$"
        // 43.
        let doublueRe2 = "^\\d{1,\(intLen)}\\.$"

        // 整数341
        let intRe = "^\\d{1,\(intLen)}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", doublueRe)
        let predicate2 = NSPredicate(format: "SELF MATCHES %@", intRe)
        let predicate3 = NSPredicate(format: "SELF MATCHES %@", doublueRe2)
        let v = predicate.evaluate(with: self)
        let v2 = predicate2.evaluate(with: self)
        let v3 = predicate3.evaluate(with: self)
        return v || v2 || v3
    }

    /// 是否是数字(包含小数)
    func isDoubNum() -> Bool {
        let regex = "^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let v = predicate.evaluate(with: self)
        return v
    }

    // 获得子字符串 包含start和end
    func getSubString(startIndex: Int, endIndex: Int) -> String {
        var endInt = endIndex
        if count < endInt {
            endInt = count
        }
        let start = index(self.startIndex, offsetBy: startIndex)
        let end = index(self.startIndex, offsetBy: endInt)
        return String(self[start...end])
    }

    /// thisiscontent  返回["this","isco","ntent"]
    func getSubStrArr(maxLen: Int) -> [String] {
        let len = count
        var suArr: [String] = []

        if len > maxLen {
            let count = len / maxLen
            for i in 0..<count {
                let index = i * maxLen
                let endIndex = index + maxLen - 1
                let subString = getSubString(startIndex: index, endIndex: endIndex)
                suArr.append(subString)
            }
            if len > count * maxLen {
                let subString = getSubString(startIndex: count * maxLen, endIndex: len - 1)
                suArr.append(subString)
            }
            return suArr
        } else {
            return [self]
        }
    }

    /// 截取字符串最大长度
    func subString(maxLength: Int) -> String {
        if count > maxLength {
            let name = getSubString(startIndex: 0, endIndex: maxLength - 1)
            return "\(name)"
        }
        return self
    }

    /// range转换为NSRange
    func rangeOfStr(subStr: String) -> NSRange {
        if subStr == "" {
            return NSMakeRange(0, 0)
        }
        if !contains(subStr) {
            return NSMakeRange(0, 0)
        }
        let range = self.range(of: subStr)!
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }

    /// 16进制字符串 转10进制整形
    func hexStrToInt() -> Int {
        let str = uppercased()
        var numbrInt = 0
        for i in str.utf8 {
            numbrInt = numbrInt * 16 + Int(i) - 48
            if i >= 65 {
                numbrInt -= 7
            }
        }
        return numbrInt
    }

    /// 十六进制转10进制
    static func hexToTen(hexNum: UInt8) -> Int {
        let str = String(format: "%02X", hexNum).uppercased()
        var numbrInt = 0
        for i in str.utf8 {
            numbrInt = numbrInt * 16 + Int(i) - 48
            if i >= 65 {
                numbrInt -= 7
            }
        }
        return numbrInt
    }

    /// 二进制字节转十六进制数组
    static func toHhex(data: Data) -> [String] {
        let str = data.map { String(format: "%02X", $0) }
            .joined(separator: ",")
        return str.split(",")
    }

    /// 转成16进制字符串如：45 32 32
    static func toHexStr(data: Data) -> String {
        let str = data.map { String(format: "%02X", $0) }.joined(separator: "")
        return str
    }

    /// Data字节转成16进制字符串如：45 32 32
    static func toHexStr(data: [UInt8]) -> String {
        let str = data.map { String(format: "%02X", $0) }.joined(separator: "")
        return str
    }

    /// hex字符串转UInt8 ---->0x06  转成 UInt8  221
    static func toUInt8(_ num: String) -> UInt8 {
        return UInt8(num, radix: 16) ?? 0
    }

    /// 比较字符串大小 （当前字符串 ： 目标字符串）
    func compar(_ objString: String) -> Int {
        let bool = compare(objString)
        if bool == ComparisonResult.orderedAscending {
            return -1
        } else if bool == ComparisonResult.orderedDescending {
            return 1
        }
        return 0 // 相等
    }
}
