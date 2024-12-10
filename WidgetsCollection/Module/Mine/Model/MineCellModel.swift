//
//  MineCellModel.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/24.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

enum MineCellEnum {
    case cellName
    case imageName
    case action
}

struct MineCellModel {
    typealias typeAction = () -> Void
    var title: String?
    var imageName: String?
    var tap: typeAction?
}
