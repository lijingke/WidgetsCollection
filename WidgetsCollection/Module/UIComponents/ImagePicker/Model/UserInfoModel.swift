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
    
    var username: String?
    var email: String?
    var role: String?
    var group_expire: String?
    var email_verified: String?
    var disk_usage: String?
    var disk_limit: String?
    var disk_usage_raw: Int64?
    var disk_limit_raw: Int64?
    
}
