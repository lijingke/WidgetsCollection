//
//  HomeDataEntity.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/7.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

struct HomeDataEntity {
    var cellName: String?
    var className: String?
    var pushType: String? = "navi"
    
    init(_ dic: [Int: String]) {
        cellName = dic[0]
        className = dic[1]
        pushType = dic[2]
    }
}
