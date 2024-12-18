//
//  AppDelegate+JPush.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/18.
//

import Foundation

// MARK: - JPUSHRegisterDelegate

extension AppDelegate: @preconcurrency JPUSHRegisterDelegate {
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> Int {
        return 0
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {}
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {}
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable: Any]?) {}
}

// MARK: - JPUSHGeofenceDelegate

extension AppDelegate: @preconcurrency JPUSHGeofenceDelegate {
    func jpushGeofenceRegion(_ geofence: [AnyHashable: Any]?, error: (any Error)?) {}
    
    func jpushCallbackGeofenceReceived(_ geofenceList: [[AnyHashable: Any]]?) {}
    
    func jpushGeofenceIdentifer(_ geofenceId: String, didEnterRegion userInfo: [AnyHashable: Any]?, error: (any Error)?) {}
    
    func jpushGeofenceIdentifer(_ geofenceId: String, didExitRegion userInfo: [AnyHashable: Any]?, error: (any Error)?) {}
}

// MARK: - JPUSHInAppMessageDelegate

extension AppDelegate: @preconcurrency JPUSHInAppMessageDelegate {
    func jPush(inAppMessageDidShow inAppMessage: JPushInAppMessage) {}
    
    func jPush(inAppMessageDidClick inAppMessage: JPushInAppMessage) {}
}
