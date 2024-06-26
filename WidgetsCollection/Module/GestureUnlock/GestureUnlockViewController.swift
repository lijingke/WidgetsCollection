//
//  GestureUnlockViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/3.
//  Copyright © 2020 李京珂. All rights reserved.
//

import LocalAuthentication
import UIKit

class GestureUnlockViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // 指纹识别
        let fingerPrint = UserDefaults.standard.value(forKey: "fingerPrint")
        if fingerPrint != nil && fingerPrint as! Bool {
            // 指纹解锁
            let authenticationContext = LAContext()
            var error: NSError?

            let isTouchIdAvailable = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

            if isTouchIdAvailable {
                print("恭喜，Touch ID可以使用！")
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要验证您的指纹来确认您的身份信息") { success, error in
                    if success {
                        let message = "恭喜，您通过了Touch ID指纹验证！"
                        NSLog(message)
                        message.ext_debugPrint()
                        // 回主线程去隐藏View,若是在子线程中隐藏则延迟太厉害
                        OperationQueue.main.addOperation {
                            print("当前线程是\(Thread.current)")
                            self.mainView.isHidden = true
                        }
                        return
                    } else {
                        print("抱歉，您未能通过Touch ID指纹验证！\n\(String(describing: error))")
                    }
                }
            } else {
                print("指纹不能用")
            }
        } else {
            print("证明没添加过")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources than can be recreated.
    }

    fileprivate func setupUI() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    lazy var mainView: GestureUnlockView = {
        let view = GestureUnlockView()
        return view
    }()
}
