//
//  Json.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/21.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

public extension Utils {
    enum Json {
        public static func fromJson<T: Decodable>(_ json: String, toClass: T.Type) -> T? {
            let jsonDecoder = JSONDecoder()
            return try? jsonDecoder.decode(toClass, from: json.data(using: .utf8)!)
        }

        public static func toJson<T: Encodable>(fromObject: T) -> String {
            let encoder = JSONEncoder()
            return String(data: try! encoder.encode(fromObject), encoding: .utf8)!
        }
    }
}
