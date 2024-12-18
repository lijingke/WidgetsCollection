//
//  AppDelegate.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/29.
//

import CoreLocation
import FirebaseCore
import FirebaseMessaging
import UIKit
import UserNotifications

@main @MainActor
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    var locationManager: CLLocationManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Override point for customization after application launch.
//        requestNoti()
//        niceNoti()
//        cancelNoti()
        FirebaseApp.configure()

        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]

        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        // [END register_for_notifications]

        // MARK: JPush

        getLocationAuthority()

        let entity = JPUSHRegisterEntity()
        if #available(iOS 12, *) {
            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
                NSInteger(UNAuthorizationOptions.sound.rawValue) |
                NSInteger(UNAuthorizationOptions.badge.rawValue) |
                NSInteger(UNAuthorizationOptions.provisional.rawValue)
        } else {
            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
                NSInteger(UNAuthorizationOptions.sound.rawValue) |
                NSInteger(UNAuthorizationOptions.badge.rawValue)
        }

        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        // 如果使用地理围栏功能，需要注册地理围栏代理
        JPUSHService.registerLbsGeofenceDelegate(self, withLaunchOptions: launchOptions)
        // 如果使用应用内消息功能，需要配置pageEnterTo:和pageLeave:接口，且可以通过设置该代理获取应用内消息的展示和点击事件
        JPUSHService.setInAppMessageDelegate(self)
        // 如不需要使用IDFA，advertisingIdentifier 可为nil
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: channel, apsForProduction: isProduction, advertisingIdentifier: nil)

        // 2.1.9版本新增获取registration id block接口。
        JPUSHService.registrationIDCompletionHandler { resCode, registrationID in
            if resCode == 0 {
                Log.info("registrationID获取成功：\(String(describing: registrationID))")
            } else {
                Log.info("registrationID获取失败，code：\(String(describing: registrationID))")
            }
        }

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
}

// MARK: - Notification

extension AppDelegate {

    // [START receive_message]
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
        -> UIBackgroundFetchResult
    {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Log.info message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            Log.info("Message ID: \(messageID)")
        }

        // Log.info full message.
        print(userInfo)
        
        // MARK: JPush
        // 注意调用
        JPUSHService.handleRemoteNotification(userInfo)
        Log.info("收到通知:\(userInfo)")

        return UIBackgroundFetchResult.newData
    }

    // [END receive_message]
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // MARK: Firebase

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Log.info message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            Log.info("Message ID: \(messageID)")
        }

        // Log.info full message.
        print(userInfo)
        
        // MARK: JPush
        // 注意调用
        JPUSHService.handleRemoteNotification(userInfo)
        Log.info("收到通知:\(userInfo)")
        completionHandler(.newData)
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        Log.info("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        Log.info("APNs token retrieved: \(deviceToken)")

        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
        
        // MARK: JPush
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidRegisterRemoteNotification"), object: deviceToken)
        // 注册devicetoken
        JPUSHService.registerDeviceToken(deviceToken)
    }
}

// MARK: - Event

extension AppDelegate {
    func niceNoti() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = "Repeating"
        content.body = "Every 1 minutes"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "repeating_360",
            content: content,
            trigger: trigger
        )

        LocalNotifications.directSchedule(
            request: request,
            permissionStrategy: .askSystemPermissionIfNeeded
        ) // completion is optional

        LocalNotifications.schedule(permissionStrategy: .askSystemPermissionIfNeeded) {
            EveryMonth(forMonths: 12, starting: .thisMonth)
                .first(.friday)
                .at(hour: 20, minute: 15)
                .schedule(title: "First Friday", body: "Oakland let's go!")
            EveryDay(forDays: 30, starting: .today)
                .at(hour: 20, minute: 30, second: 30)
                .schedule(with: content(forTriggerDate:))
        }
    }

    func content(forTriggerDate date: Date) -> NotificationContent {
        // create content based on date
        return NotificationContent(title: "", subtitle: nil, body: "", sound: .default)
    }

    func cancelNoti() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func requestNoti() {
        // 请求权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            guard granted else { return }

            // 创建通知内容
            let content = UNMutableNotificationContent()
            content.title = "My Notification"
            let time = DateUtil.getDateStr(interval: Date().timeIntervalSince1970, format: "yyyy-MM-dd HH:mm:ss")
            content.body = "Hello, this is a local notification!\nTime is \(time)"
            content.sound = UNNotificationSound.default

            // 创建触发器
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

            // 创建请求
            let request = UNNotificationRequest(identifier: "myLocalNotification", content: content, trigger: trigger)

            // 添加请求到通知中心
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    Log.info(error.localizedDescription)
                }
            }
        }
    }
}
