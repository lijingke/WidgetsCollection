//
//  Bool+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/28.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

public extension Bool {
    var toInt: Int { return self ? 1 : 0 }

    @discardableResult
    mutating func toggled() -> Bool {
        self = !self
        return self
    }
}
