//
//  PDFEntity.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import Foundation

struct PDFEntity {
    /// PDF封面
    var cover: String?
    /// PDF名称
    var name: String?
    /// PDF编号
    var indexInfo: String?
    /// PDF阅读人数
    var readNum: String?
    /// PDF下载路径
    var filePath: String?
    
    /// 是否已下载
    var hasDownload: Bool?
}
