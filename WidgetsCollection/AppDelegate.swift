//
//  AppDelegate.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        requestNoti()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func requestNoti() {
        // 请求权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            guard granted else { return }
         
            // 创建通知内容
            let content = UNMutableNotificationContent()
            content.title = "My Notification"
            content.body = "Hello, this is a local notification!"
            content.sound = UNNotificationSound.default
         
            // 创建触发器
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
         
            // 创建请求
            let request = UNNotificationRequest(identifier: "myLocalNotification", content: content, trigger: trigger)
         
            // 添加请求到通知中心
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
