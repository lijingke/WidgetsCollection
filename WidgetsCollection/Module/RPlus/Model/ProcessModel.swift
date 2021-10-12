//
//  ProcessModel.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/12.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import HandyJSON


struct ProcessModel: HandyJSON {
    /// 类型：1-已完成，2-进行中，3-未开始，4-提示，5-已完成分割，6-未完成分割
    var type: Int?
    /// 流程名
    var title: String?
    /// 是否可修改
    var canEdit: Bool = false
    /// 提示内容
    var tipsContent: String?
    /// 进行中提示
    var inProcessHint: String?
}
