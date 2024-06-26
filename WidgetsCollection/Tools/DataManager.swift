//
//  DataManager.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/11.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(255) + 1) / 255
        let green = CGFloat(arc4random_uniform(255) + 1) / 255
        let blue = CGFloat(arc4random_uniform(255) + 1) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

class DataManager {
    static let shared = DataManager()

    func generalColor(_ count: Int) -> [UIColor] {
        var colors = [UIColor]()
        for _ in 0 ..< count {
            colors.append(UIColor.randomColor())
        }
        return colors
    }

    let randomText = "黑发不知勤学早白首方悔读书迟迟日江山丽春风花草香杜甫绝句春色满园关不住一枝红杏出墙来叶绍翁游园不值好雨知时节当春乃发生杜甫春雨夏天小荷才露尖尖角早有蜻蜓立上头杨万里小池接天莲叶无穷碧映日荷花别样红"

    func generalText() -> String {
        let textCount = randomText.count
        let randomIndex = arc4random_uniform(UInt32(textCount))
        let start = max(0, Int(randomIndex) - 7)
        let startIndex = randomText.startIndex
        let step = arc4random_uniform(5) + 2
        let startTextIndex = randomText.index(startIndex, offsetBy: start)
        let endTextIndex = randomText.index(startIndex, offsetBy: start + Int(step))
        let text = String(randomText[startTextIndex ..< endTextIndex])
        return text
    }

    func generalTags() -> [[String]] {
        var tags1: [String] = []
        var tags2: [String] = []
        var tags3: [String] = []

        for i in 0 ..< 50 {
            if i % 3 == 0 {
                tags1.append(generalText())
            }
            if i % 2 == 0 {
                tags2.append(generalText())
            }
            tags3.append(generalText())
        }
        return [tags1, tags2, tags3]
    }
}
