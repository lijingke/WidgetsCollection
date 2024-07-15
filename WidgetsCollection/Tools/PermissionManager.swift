//
//  PermissionManager.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/15.
//

import Foundation
import PermissionsKit

class PermissionManager: NSObject {
    static let sharedInstance = PermissionManager()

    /// 获取相机权限
    /// - Parameter deniedHandler: 拒绝权限时的回调
    func requestCameraPermission(deniedHandler: @escaping () -> Void) {
        Permission.camera.request {
            let status = Permission.camera.status
            if status == .denied {
                deniedHandler()
            }
        }
    }

    /// 获取相册权限
    /// - Parameter deniedHandler: 拒绝权限时的回调
    func requestPhotoLibraryPermission(deniedHandler: @escaping () -> Void) {
        Permission.photoLibrary.request {
            let status = Permission.photoLibrary.status
            if status == .denied {
                deniedHandler()
            }
        }
    }

    /// 获取媒体权限
    /// - Parameter deniedHandler: 拒绝权限时的回调
    func requesMediaLibraryPermission(deniedHandler: @escaping () -> Void) {
        Permission.mediaLibrary.request {
            let status = Permission.mediaLibrary.status
            if status == .denied {
                deniedHandler()
            }
        }
    }

    /// 获取蓝牙权限
    /// - Parameter deniedHandler: 拒绝权限时的回调
    func requesBluetoothPermission(deniedHandler: @escaping () -> Void) {
        Permission.bluetooth.request {
            let status = Permission.bluetooth.status
            if status == .denied {
                deniedHandler()
            }
        }
    }

    /// 获取健康权限
    /// - Parameter deniedHandler: 拒绝权限时的回调
    func requesHealthPermission(deniedHandler _: @escaping () -> Void) {
//        HealthPermission.status(for: .)
//        let status = Permission.health.status
//        Log.info("\(status)")
//        if status == .denied {
//            Permission.health.openSettingPage()
//        } else {
//            Permission.health.request {
//
//            }
//        }
    }
}
