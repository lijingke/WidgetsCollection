//
//  AttributedStringViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/26.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

class AttributedStringViewController: UIViewController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        changeLabel()
    }
    
    // MARK: Lazy Get
    lazy var contentLabel: ActiveLabel = {
        let label = ActiveLabel()
        let customType = ActiveType.custom(pattern: "\\s李京珂\\b") //Regex that looks for "with"
        label.enabledTypes = [.mention, .hashtag, .url, customType]
        label.text = "This is a 李京珂 with #hashtags and a @userhandle."
        label.customColor[customType] = UIColor.purple
//        label.customSelectedColor[customType] = UIColor.green
        label.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
        }
        return label
    }()
}

extension AttributedStringViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func changeLabel() {
        // 1.定义一个字符串
        // 将String类型转换成 NSString,否则在第五步获取range时类型转换很麻烦
        let contentStr = " Swift3.0 富文本的使用@111111,改变行间距、添加点击事件@222222"  as NSString
        // 2.初始化富文本
        let nameStr : NSMutableAttributedString = NSMutableAttributedString(string:contentStr as String)
        
        // 3.添加样式 (行间距和对其方式)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .left
        // 4.行间距
        nameStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, contentStr.length))
        // 5.关键代码 添加事件
        let range = contentStr.range(of: "@111111", options: .regularExpression, range: NSMakeRange(0,contentStr.length))
        let range1 = contentStr.range(of: "@222222", options: .regularExpression, range: NSMakeRange(0,contentStr.length))
        nameStr.addAttribute(NSAttributedString.Key.link, value: "frist://", range: range)
        nameStr.addAttribute(NSAttributedString.Key.link, value: "second://", range: range1)
//        contentLabel.attributedText = nameStr
    }
    
}
