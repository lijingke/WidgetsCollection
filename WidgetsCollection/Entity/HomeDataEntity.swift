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

enum PushType: String {
    case navi
    case present
    case nib
}

struct HomeDataEntity {
    var cellName: String?
    var className: String?
    var pushType: PushType = .navi

    init(_ dic: [CellInfoEnum: Any]) {
        cellName = dic[.cellName] as? String
        className = dic[.className] as? String
        pushType = dic[.pushType] as? PushType ?? .navi
    }
}
