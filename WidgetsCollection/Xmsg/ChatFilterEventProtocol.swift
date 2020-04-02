//
//  ChatFilterEventProtocol.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/1/2.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

protocol ChatFilterEventProtocol: NSObject {
  func confirmAction( choosedDefultTags: [tagViewModel], customMembers: [String], customTags:[String])
  func tagChoosed(atInsexPath: IndexPath, tag: tagViewModel)
}

extension ChatFilterEventProtocol {
  func confirmAction( choosedDefultTags: [tagViewModel], customMembers: [String], customTags:[String]) {}
  func tagChoosed(atInsexPath: IndexPath, tag: tagViewModel) {}
}
