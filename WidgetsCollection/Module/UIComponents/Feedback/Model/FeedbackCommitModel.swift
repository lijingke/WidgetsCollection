//
//  FeedbackCommitModel.swift
//  OnFit
//
//  Created by 李京珂 on 2024/11/13.
//

import Foundation

class FeedbackCommitModel {
    /// 问题类型
    var issueContent: String?
    /// 问题类型枚举
    var issue_type: String? {
        switch issueContent {
        case R.string.localizables.feedBackIssuesRadio1():
            return "健身内容"
        case R.string.localizables.feedBackIssuesRadio2():
            return "锻炼难度"
        case R.string.localizables.feedBackIssuesRadio3():
            return "订阅"
        case R.string.localizables.feedBackIssuesRadio4():
            return "其他"
        default:
            return nil
        }
    }
    /// 问题描述
    var issue_description: String?
    /// 期望健身内容
    var fitness_content: String?
    /// 其他内容
    var other_content: String?
    var email: String?
}
