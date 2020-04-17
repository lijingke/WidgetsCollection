//
//  Array+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/16.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

extension Array {
    
    func array2NSMutableArray() -> NSMutableArray {
        let NSMutableArray: NSMutableArray = []
        for item in self {
            NSMutableArray.add(item)
        }
        return NSMutableArray
    }
}
