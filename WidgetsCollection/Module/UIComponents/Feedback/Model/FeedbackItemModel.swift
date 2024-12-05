//
//  FeedbackItemModel.swift
//  OnFit
//
//  Created by 李京珂 on 2024/11/11.
//

import Foundation

enum FeedbackItemType {
    case radioButton
    case textFiled
    case redioButtonAndField
}

class FeedbackRadioItem: Equatable {

    static func == (lhs: FeedbackRadioItem, rhs: FeedbackRadioItem) -> Bool {
        return lhs.value == rhs.value
    }
    
    var value: String
    var isSelected: Bool = false
    
    init(value: String) {
        self.value = value
    }
}

class FeedbackItemModel {
    
    /// 标题
    var title: String?
    /// 类型，选择或者输入
    var type: FeedbackItemType?
    /// 用户选择的值或者输入的内容
    @Published var value: String?
    /// 单选项数组
    var radioArr: [FeedbackRadioItem] = []
    /// 用户输入的补充内容
    var additionalContent: String?
    /// 补充框的占位文案
    var placeHolder: String?
    /// 标签，用来筛选查找使用
    var tag: Int?
    /// 选择其他时显示的输入框
    var showOtherInputField: Bool = false

    init() {}
}
