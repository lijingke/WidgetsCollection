//
//  UploadHistoryModel.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/21.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation
import HandyJSON

struct UploadHistoryModel: HandyJSON {
    var width: CGFloat?
    var height: CGFloat?
    var filename: String?
    var storename: String?
    var size: Int64?
    var path: String?
    var hash: String?
    var created_at: Int64?
    var url: String?
    var delete: String?
    var page: String?
}
