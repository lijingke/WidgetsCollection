//
//  RefreshCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/8/3.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class RefreshCell: UITableViewCell {
    
    // MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
