//
//  AppDelegate.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/3.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = MainTabbarController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }


}

