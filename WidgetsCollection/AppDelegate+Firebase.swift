//
//  AppDelegate+Firebase.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/18.
//

import FirebaseCore
import FirebaseMessaging
import Foundation

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    nonisolated func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    // [END refresh_token]
}
