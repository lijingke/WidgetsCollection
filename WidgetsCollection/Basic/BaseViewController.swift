//
//  BaseViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Combine
import Foundation
import UIKit

class BaseViewController: UIViewController {
    var isSlidePopGestureEnable = false
    
    var cancellableSet = Set<AnyCancellable>()

    override var view: UIView! {
        didSet {
            initSlidePopGesture()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initNavigator(controller: navigationController as? BaseNavigationController)
        addCaptureListener()
    }

    @objc func feedback(type _: Int = 0) {
//        Log.info(type == 0 ? "摇一摇" :  "截屏")
        FeedbackManager.shared.showView()
    }

    @objc func addCaptureListener() {
        // 监听截屏通知

        NotificationCenter.default.addObserver(self, selector: #selector(screenshots), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        // 监听录屏通知,iOS 11后才有录屏
        if UIDevice.current.systemVersion >= "11.0" {
            // 如果正在捕获此屏幕（例如，录制、空中播放、镜像等），则为真
            if UIScreen.main.isCaptured {
                screenshots()
            }
            // 捕获的屏幕状态发生变化时,会发送UIScreenCapturedDidChange通知,监听该通知
            NotificationCenter.default.addObserver(self, selector: #selector(screenshots), name: UIScreen.capturedDidChangeNotification, object: nil)
        }
    }

    @objc func removeCaputureListener() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        if UIDevice.current.systemVersion >= "11.0" {
            NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
        }
    }

    // 提示用户
    @objc func screenshots() {
        // 只添加视图到其他控制器中的vc不弹，比如web，避免弹2次弹窗
        if parent == nil { return }
        let alertVC = UIAlertController(title: "提示", message: "是否遇到问题需要反馈？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "是", style: .default, handler: { _ in
            alertVC.dismiss(animated: true, completion: nil)
            self.feedback(type: 1)
        })
        let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }

    private func initNavigator(controller: BaseNavigationController?) {
        if let config = getNavigatorConfig() {
            if let title = config.title {
                controller?.setTitle(title: title, subTitle: config.subTitle, action: config.titleSelector)
            }
            if let leftBarButton = config.leftBarButton {
                controller?.setLeftBarButton(title: leftBarButton.buttonTitle, titleAttrs: leftBarButton.buttonTitleAttrs, image: leftBarButton.buttonBg, action: leftBarButton.buttonSelector!)
            }
            
            if let rightBarButton = config.rightBarButton {
                controller?.setRightBarButton(title: rightBarButton.buttonTitle, titleAttrs: rightBarButton.buttonTitleAttrs, image: rightBarButton.buttonBg, action: rightBarButton.buttonSelector!)
            }
        }
    }
    
    func getNavigatorConfig() -> NavigatorConfig? {
        return NavigatorConfig.newConfig()
    }
    
    func updateNavigator() {
        initNavigator(controller: navigationController as? BaseNavigationController)
    }
    
    func initSlidePopGesture() {
        if isSlidePopGestureEnable {
            let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(onSlidePop))
            gesture.edges = .left
            view.addGestureRecognizer(gesture)
        }
    }
    
    @objc private func onSlidePop() {
        if let navCtrl = navigationController {
            if self != navCtrl.viewControllers.first {
                navCtrl.popViewController(animated: true)
            }
        }
    }
    
    func setAutoRotate(enable: Bool) {
        if let navCtrl = navigationController as? BaseNavigationController {
            navCtrl.setAutoRotate(enable: enable)
        }
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        debugPrint("init BaseViewController class :\(String(describing: type(of: self)))")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        debugPrint("init coder BaseViewController class :\(String(describing: type(of: self)))")
    }
    
    deinit {
        debugPrint("deinit BaseViewController class :\(String(describing: type(of: self)))")
        removeCaputureListener()
    }
}
