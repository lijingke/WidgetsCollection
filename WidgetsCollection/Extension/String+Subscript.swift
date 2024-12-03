//
//  String+Subscript.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/3.
//

import Foundation

public extension String {
    subscript(value: Int) -> String {
        let upperBound = min(value, self.count-1)
        return String(self[index(at: upperBound)])
    }
}

public extension String {
    subscript(value: NSRange) -> String {
        self[value.lowerBound..<value.upperBound]
    }
}

public extension String {
    /// 使用下标截取字符串 例: "示例字符串"[0..<2] 结果是 "示例"
//    subscript(r: Range<Int>) -> String {
//        if (r.lowerBound > count) || (r.upperBound > count) { return "截取超出范围" }
//        let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
//        let endIndex = index(self.startIndex, offsetBy: r.upperBound)
//        return String(self[startIndex..<endIndex])
//    }

    subscript(bounds: CountableClosedRange<Int>) -> String {
        let lowerBound = max(0, bounds.lowerBound)
        guard lowerBound < self.count else { return "" }

        let upperBound = min(bounds.upperBound, self.count-1)
        guard upperBound >= 0 else { return "" }

        return String(self[index(at: lowerBound)...index(at: upperBound)])
    }

    subscript(bounds: CountableRange<Int>) -> String {
        let lowerBound = max(0, bounds.lowerBound)
        guard lowerBound < self.count else { return "" }

        let upperBound = min(bounds.upperBound, self.count-1)
        guard upperBound >= 0 else { return "" }
        
        return String(self[index(at: lowerBound)..<index(at: upperBound)])
    }

    subscript(bounds: PartialRangeUpTo<Int>) -> String {
        let upperBound = min(bounds.upperBound, self.count-1)
        guard upperBound >= 0 else { return "" }
        return String(self[..<index(at: upperBound)])
    }

    subscript(bounds: PartialRangeThrough<Int>) -> String {
        let upperBound = min(bounds.upperBound, self.count-1)
        guard upperBound >= 0 else { return "" }
        return String(self[...index(at: upperBound)])
    }

    subscript(bounds: PartialRangeFrom<Int>) -> String {
        let lowerBound = max(0, bounds.lowerBound)
        guard lowerBound <= self.count-1 else { return "" }
        return String(self[index(at: bounds.lowerBound)...])
    }
}

private extension String {
    func index(at offset: Int) -> String.Index {
        self.index(startIndex, offsetBy: offset)
    }
}
