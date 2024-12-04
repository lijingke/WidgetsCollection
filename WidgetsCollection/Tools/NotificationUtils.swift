//
//  NotificationUtils.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/4.
//

import Foundation

class NotificationUtils {
    static func publisher(name: String, object: Any? = nil) -> NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: Notification.Name(name), object: nil)
    }
    
    static func post(name: String, object: Any? = nil) {
        NotificationCenter.default.post(name: Notification.Name(name), object: object)
    }
    
    static func addObserver(observer: Any, selector: Selector, name: String, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(name), object: object)
    }
    
    static func addObserver(observer: Any, selector: Selector, notificationName: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: object)
    }
    
    static func removeObserver(observer: Any, name: String? = nil, object: Any? = nil) {
        if let name = name {
            NotificationCenter.default.removeObserver(observer, name: Notification.Name(name), object: object)
        } else {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}


