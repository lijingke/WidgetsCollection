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

//        // Define a listener to handle the case when a screen recording is launched
//        // for example using the iPhone built-in feature
//        NotificationCenter.default.addObserver(self, selector: #selector(didScreenRecording(_:)), name: UIScreen.capturedDidChangeNotification, object: nil)
//
//        // Define a listener to handle the case when a screenshot is performed
//        // Unfortunately screenshot cannot be prevented but just detected...
//        NotificationCenter.default.addObserver(self, selector: #selector(didScreenshot(_:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vc = MainTabbarController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }

    @objc private func didScreenshot(_ notification: Notification) {
        
#if DEBUG
            // Never add this log in RELEASED app.
            print("Screen capture detected then we force the immediate exit of the app!")
#endif
        // Information about the image is not available here and screenshot cannot be prevented AS IS
        // See hint here about a way to address this issue:
        // https://tumblr.jeremyjohnstone.com/post/38503925370/how-to-detect-screenshots-on-ios-like-snapchat
        // In all case: Send notification to the backend and clear all local data/secret from the storage/keychain
        exit(0)
    }

    @objc private func didScreenRecording(_ notification: Notification) {
        // If a screen recording operation is pending then we close the application
        print(UIScreen.main.isCaptured)
        if UIScreen.main.isCaptured {
#if DEBUG
            // Never add this log in RELEASED app.
            print("Screen recording detected then we force the immediate exit of the app!")
#endif
            exit(0)
        }
    }
}
