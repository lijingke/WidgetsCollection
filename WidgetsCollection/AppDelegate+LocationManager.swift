//
//  AppDelegate+LocationManager.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/18.
//

import Foundation
import CoreLocation

// MARK: - CLLocationManagerDelegate

extension AppDelegate: @preconcurrency CLLocationManagerDelegate {
    // MARK: - location

    func getLocationAuthority() {
        locationManager = CLLocationManager()
        if #available(iOS 8.0, *) {
            locationManager?.requestAlwaysAuthorization()
        } else {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                print("kCLAuthorizationStatusNotDetermined")
            }
        }
        locationManager?.delegate = self
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            print("获取地理位置权限成功")
        }
    }
}
