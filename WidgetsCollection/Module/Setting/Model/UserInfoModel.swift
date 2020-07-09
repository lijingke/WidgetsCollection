//
//  UserInfoModel.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/21.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation
import HandyJSON

struct UserInfoModel: HandyJSON {
    
    /// 用户名称
    var username: String?
    /// 电子邮件
    var email: String?
    /// 角色
    var role: String?
    /// 付费版到期时间
    var group_expire: String?
    /// 是否已验证邮件地址
    var email_verified: Int?
    /// 已用空间
    var disk_usage: String?
    /// 总共空间
    var disk_limit: String?
    /// 已用空间字节
    var disk_usage_raw: Int64?
    /// 所有空间字节
    var disk_limit_raw: Int64?
}
