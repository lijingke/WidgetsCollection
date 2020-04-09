//
//  HomeDataEntity.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/7.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

enum CellInfoEnum {
    case cellName
    case className
    case pushType
}

struct HomeDataEntity {
    var cellName: String?
    var className: String?
    var pushType: String? = "navi"
    
    init(_ dic: [CellInfoEnum: String]) {
        cellName = dic[.cellName]
        className = dic[.className]
        pushType = dic[.pushType]
    }
}
