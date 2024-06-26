//
//  MBProgressManager.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/24.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation
import MBProgressHUD

enum HUDMaskType: Int {
    case none = 0
    case clear = 1
}

enum HUDInViewType {
    case keyWindow
    case currentWindow
}

enum HUDShowStateType {
    case success
    case error
    case warning
}

class MBProgressManager: NSObject {
    // MARK: - 全都可以使用的参数

    private var inView: UIView
    private var animated: Bool
    private var maskType: HUDMaskType

    // MARK: - 只有showHandleMessage可以使用的属性

    private var customView: UIView?
    private var customIconName: String?
    private var message: String?
    private var afterDelay: TimeInterval
    private var hudColor: UIColor?
    private var contentColor: UIColor?
    private var hudMode: MBProgressHUDMode

    /// 设置全局的HUD类型
    private var hudState: HUDShowStateType?
    /// 进度条进度
    public var progressValue: CGFloat = 0
    /// 自定义动画的持续时间
    private var animationDuration: CGFloat?
    /// 自定义动画的图片数组
    private var imageArray: [UIImage]?
    /// 自定义的图片名称
    private var imageStr: String?

    override init() {
        inView = UIApplication.shared.windows[0]
        maskType = .clear
        afterDelay = 0.6
        animated = true
        hudColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        contentColor = .white
        hudMode = .indeterminate
        super.init()
    }

    // MARK: - 配置HUD

    static func configHUD(with makeObj: MBProgressManager) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: makeObj.inView, animated: makeObj.animated)
        hud.detailsLabel.text = makeObj.message
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 16)
        hud.bezelView.color = makeObj.hudColor
        hud.contentColor = makeObj.contentColor
        hud.animationType = .zoomOut
        hud.isUserInteractionEnabled = makeObj.maskType.rawValue.boolValue
        hud.mode = makeObj.hudMode
        hud.removeFromSuperViewOnHide = true
        hud.bezelView.blurEffectStyle = .regular
        return hud
    }

    // MARK: - 简单的显示方法

    @discardableResult
    static func showLoadingOrdinary(_ loadingString: String) -> MBProgressHUD {
        return MBProgressManager.showHUDCustom { make in
            make.message(loadingString)
        }
    }

    // MARK: - 简单的显示方法(加在指定view上)

    @discardableResult
    static func showLoadingOrdinary(_ loadingString: String, in inView: UIView) -> MBProgressHUD {
        return MBProgressManager.showHUDCustom { make in
            make.inView(inView).message(loadingString)
        }
    }

    // MARK: - 复杂的显示方式可以用此方法自定义

    @discardableResult
    static func showHUDCustom(_ block: @escaping ((_ make: MBProgressManager) -> Void)) -> MBProgressHUD {
        let makeObj = MBProgressManager()
        block(makeObj)

        var hud: MBProgressHUD?

        DispatchQueue.main.async {
            hud = MBProgressManager.configHUD(with: makeObj)
            switch makeObj.hudMode {
            case .indeterminate:
                hud?.minSize = CGSize(width: 90, height: 100)
            case .determinate:
                break
            case .determinateHorizontalBar:
                break
            case .annularDeterminate:
                break
            case .customView:
                if makeObj.imageArray?.count ?? 0 > 0 {
                    let image = makeObj.imageArray?.first?.withRenderingMode(.alwaysTemplate)
                    let mainImageView = UIImageView(image: image)
                    mainImageView.animationImages = makeObj.imageArray
                    mainImageView.animationDuration = TimeInterval(makeObj.animationDuration ?? 0)
                    mainImageView.animationRepeatCount = 0
                    mainImageView.startAnimating()
                    hud?.customView = mainImageView
                } else if makeObj.imageStr?.count ?? 0 > 0 {
                    hud?.customView = UIImageView(image: UIImage(named: makeObj.imageStr ?? "")?.withRenderingMode(.automatic))
                }

                if makeObj.hudColor?.cgColor == UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor {
                    hud?.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    hud?.contentColor = makeObj.contentColor
                } else {
                    hud?.bezelView.color = makeObj.hudColor
                    hud?.contentColor = makeObj.contentColor
                }
            case .text:
                break
            default:
                break
            }
        }

        return hud ?? MBProgressHUD()
    }

    // MARK: - 简单的改变进度条

    static func uploadProgressOrdinary(_ progressValue: CGFloat) {
        MBProgressManager.uploadProgressValue { make in
            make.progressValue(progressValue)
        }
    }

    // MARK: - 简单的改变进度条值(加在指定view上)

    static func uploadProgressOrdinary(_ progressValue: CGFloat, inView: UIView) {
        MBProgressManager.uploadProgressValue { make in
            make.inView(inView).progressValue(progressValue)
        }
    }

    // MARK: - 复杂的改变进度条值可以用此方法自定义

    static func uploadProgressValue(_ block: @escaping ((_ make: MBProgressManager) -> Void)) {
        let makeObj = MBProgressManager()
        block(makeObj)
        let hud = MBProgressHUD.forView(makeObj.inView)
        hud?.progress = Float(makeObj.progressValue)
    }

    // MARK: - 显示成功并自动消失

    static func showHUD(withSuccess showString: String) {
        MBProgressManager.showHUD { make in
            make.hudState(.success).message(showString)
        }
    }

    // MARK: - 显示成功并自动消失(指定view上)

    static func showHUD(withSuccess showString: String, in inView: UIView) {
        MBProgressManager.showHUD { make in
            make.inView(inView).hudState(.success).message(showString)
        }
    }

    // MARK: - 显示错误并自动消失

    static func showHUD(withError showString: String) {
        MBProgressManager.showHUD { make in
            make.hudState(.error).message(showString)
        }
    }

    // MARK: - 显示错误并自动消失(指定view上)

    static func showHUD(withError showSting: String, in inView: UIView) {
        MBProgressManager.showHUD { make in
            make.inView(inView).hudState(.error).message(showSting)
        }
    }

    // MARK: - 显示警告并自动消失

    static func showHUD(withWarning showString: String) {
        MBProgressManager.showHUD { make in
            make.hudState(.warning).message(showString)
        }
    }

    // MARK: - 显示警告并自动消失(指定view上)

    static func showHUD(withWarning showString: String, in inView: UIView) {
        MBProgressManager.showHUD { make in
            make.inView(inView).hudState(.warning).message(showString)
        }
    }

    // MARK: - 显示纯文字并自动消失

    static func showHUD(withText showString: String) {
        MBProgressManager.showHUD { make in
            make.message(showString)
        }
    }

    // MARK: - 显示纯文字并自动消失(指定view上)

    static func showHUD(withText showString: String, in inView: UIView) {
        MBProgressManager.showHUD { make in
            make.inView(inView).message(showString)
        }
    }

    // MARK: - 显示状态自定义（自动消失）

    static func showHUD(withState block: @escaping ((_ make: MBProgressManager) -> Void)) {
        let makeObj = MBProgressManager()
        block(makeObj)
        var hud = MBProgressHUD.forView(makeObj.inView)
        DispatchQueue.main.async {
            if hud == nil {
                hud = MBProgressManager.configHUD(with: makeObj)
            }
            hud?.mode = .customView
            hud?.detailsLabel.text = makeObj.message
            hud?.isUserInteractionEnabled = makeObj.maskType.rawValue.boolValue

            var imageStr = ""
            switch makeObj.hudState {
            case .success:
                imageStr = "hudSuccess"
            case .error:
                imageStr = "hudError"
            case .warning:
                imageStr = "hudInfo"
            default:
                hud?.minSize = CGSize(width: 40, height: 30)
            }

            hud?.customView = UIImageView(image: UIImage(named: imageStr)?.withRenderingMode(.alwaysTemplate))
            hud?.hide(animated: makeObj.animated, afterDelay: makeObj.afterDelay)
        }
    }

    // MARK: - 直接消失

    static func dismissHUDDirect() {
        MBProgressManager.dismissHUD(nil)
    }

    // MARK: - 直接消失（指定view）

    static func dismissHUDDirect(in inView: UIView) {
        MBProgressManager.dismissHUD { make in
            make.inView(inView)
        }
    }

    static func dismissHUD(_ block: ((_ make: MBProgressManager) -> Void)?) {
        let makeObj = MBProgressManager()
        block?(makeObj)
        let hud = MBProgressHUD.forView(makeObj.inView)
        hud?.hide(animated: makeObj.animated)
    }
}

extension MBProgressManager {
    @discardableResult
    func inView(_ view: UIView) -> MBProgressManager {
        inView = view
        return self
    }

    @discardableResult
    func customView(_ view: UIView) -> MBProgressManager {
        customView = view
        return self
    }

    @discardableResult
    func customIconName(_ name: String) -> MBProgressManager {
        customIconName = name
        return self
    }

    @discardableResult
    func inViewType(_ inViewType: HUDInViewType) -> MBProgressManager {
        switch inViewType {
        case .keyWindow:
            inView = UIApplication.shared.windows[0]
        case .currentWindow:
            inView = UIApplication.shared.windows[0].rootViewController?.view ?? UIView()
        }
        return self
    }

    @discardableResult
    func animated(_ animated: Bool) -> MBProgressManager {
        self.animated = animated
        return self
    }

    @discardableResult
    func maskType(_ maskType: HUDMaskType) -> MBProgressManager {
        self.maskType = maskType
        return self
    }

    @discardableResult
    func afterDelay(_ afterDelay: TimeInterval) -> MBProgressManager {
        self.afterDelay = afterDelay
        return self
    }

    @discardableResult
    func message(_ message: String) -> MBProgressManager {
        self.message = message
        return self
    }

    @discardableResult
    func hudColor(_ hudColor: UIColor) -> MBProgressManager {
        self.hudColor = hudColor
        return self
    }

    @discardableResult
    func hudMode(_ hudMode: MBProgressHUDMode) -> MBProgressManager {
        self.hudMode = hudMode
        return self
    }

    @discardableResult
    func hudState(_ hudState: HUDShowStateType) -> MBProgressManager {
        self.hudState = hudState
        return self
    }

    @discardableResult
    func progressValue(_ progressValue: CGFloat) -> MBProgressManager {
        self.progressValue = progressValue
        return self
    }

    @discardableResult
    func animationDuration(_ animationDuration: CGFloat) -> MBProgressManager {
        self.animationDuration = animationDuration
        return self
    }

    @discardableResult
    func imageArray(_ imageArray: [UIImage?]) -> MBProgressManager {
        var temp: [UIImage] = []

        for image in imageArray {
            if let image = image {
                temp.append(image)
            }
        }

        self.imageArray = temp
        return self
    }

    @discardableResult
    func contentColor(_ contentColor: UIColor) -> MBProgressManager {
        self.contentColor = contentColor
        return self
    }

    @discardableResult
    func imageStr(_ imageStr: String) -> Self {
        self.imageStr = imageStr
        return self
    }
}
