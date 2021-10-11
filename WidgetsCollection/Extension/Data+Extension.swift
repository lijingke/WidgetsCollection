//
//  Data+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import Foundation
import SwiftyJSON

extension Data {
    /// 转字典
    func toDic() -> [String: Any] {
        do {
            let json = try JSON(data: self)
            let dic = json.dictionaryObject!
            return dic

        } catch _ {
            return [:]
        }
    }
}
