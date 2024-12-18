//
//  AppDelegate+JPush.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/18.
//

import Foundation

let appKey = "3f9fc523e0f239bc04444ffa"
let channel = "Publish channel"
let isProduction = false

// MARK: - JPUSHRegisterDelegate

extension AppDelegate: @preconcurrency JPUSHRegisterDelegate {
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let request = response.notification.request // 收到推送的请求
//        let content = request.content // 收到推送的消息内容

//        let badge = content.badge // 推送消息的角标
//        let body = content.body   // 推送消息体
//        let sound = content.sound // 推送消息的声音
//        let subtitle = content.subtitle // 推送消息的副标题
//        let title = content.title // 推送消息的标题

        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {
            // 注意调用
            JPUSHService.handleRemoteNotification(userInfo)
            print("iOS10 收到远程通知:\(userInfo)")

        } else {
            print("iOS10 收到本地通知:\(userInfo)")
        }

        completionHandler()
    }

    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (Int) -> Void) {
        let userInfo = notification.request.content.userInfo
        let request = notification.request // 收到推送的请求
//        let content = request.content // 收到推送的消息内容

//        let badge = content.badge // 推送消息的角标
//        let body = content.body   // 推送消息体
//        let sound = content.sound // 推送消息的声音
//        let subtitle = content.subtitle // 推送消息的副标题
//        let title = content.title // 推送消息的标题

        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {
            // 注意调用
            JPUSHService.handleRemoteNotification(userInfo)
            print("iOS10 收到远程通知:\(userInfo)")
            addNotificationCount()
        } else {
            print("iOS10 收到本地通知:\(userInfo)")
        }

        completionHandler(Int(UNNotificationPresentationOptions.badge.rawValue | UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.alert.rawValue))
    }

    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {}

    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable: Any]?) {
        Log.info("receive notification authorization status:\(status), info:\(String(describing: info))")
    }
}

// MARK: - JPUSHGeofenceDelegate

extension AppDelegate: @preconcurrency JPUSHGeofenceDelegate {
    func jpushGeofenceRegion(_ geofence: [AnyHashable: Any]?, error: (any Error)?) {
        Log.info("geofence: \(String(describing: geofence)), error: \(String(describing: error))")
    }

    func jpushCallbackGeofenceReceived(_ geofenceList: [[AnyHashable: Any]]?) {
        Log.info("geofenceList: \(String(describing: geofenceList))")
    }

    // 进入地理围栏区域
    func jpushGeofenceIdentifer(_ geofenceId: String, didEnterRegion userInfo: [AnyHashable: Any]?, error: (any Error)?) {
        Log.info("didEnterRegion")
    }

    // 离开地理围栏区域
    func jpushGeofenceIdentifer(_ geofenceId: String, didExitRegion userInfo: [AnyHashable: Any]?, error: (any Error)?) {
        Log.info("didExitRegion")
    }
}

// MARK: - JPUSHInAppMessageDelegate

extension AppDelegate: @preconcurrency JPUSHInAppMessageDelegate {
    func jPush(inAppMessageDidShow inAppMessage: JPushInAppMessage) {
        let messageId = inAppMessage.mesageId
        let title = inAppMessage.title
        let content = inAppMessage.content
        // ... 更多参数获取请查看JPushInAppMessage
        Log.info("jPushInAppMessageDidShow - messageId:\(messageId), title:\(title), content:\(content)")
    }

    func jPush(inAppMessageDidClick inAppMessage: JPushInAppMessage) {
        let messageId = inAppMessage.mesageId
        let title = inAppMessage.title
        let content = inAppMessage.content
        // ... 更多参数获取请查看JPushInAppMessage
        Log.info("jPushInAppMessageDidClick - messageId:\(messageId), title:\(title), content:\(content)")
    }
}

extension AppDelegate {
    // MARK: - other

    func addNotificationCount() {
        let tabbarVC = kWindow?.rootViewController as? UITabBarController
        let rootViewVC = tabbarVC?.viewControllers!.first as? RootViewController
        rootViewVC?.addNotificationCount()
    }
}
