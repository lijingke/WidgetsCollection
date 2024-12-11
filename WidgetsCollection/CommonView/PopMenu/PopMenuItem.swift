//
//  PopMenuItem.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import Foundation

struct PopMenu {
    var icon: String?
    var title: String

    init(title: String, icon: String? = nil) {
        self.title = title
        self.icon = icon
    }
}
