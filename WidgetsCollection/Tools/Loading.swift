//
//  Loading.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/24.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation
import MBProgressHUD

class Loading {
    
    static public func showLoading(with msg: String = "", to view: UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.color = UIColor(white: 0, alpha: 0.7)
        hud.bezelView.blurEffectStyle = .regular
        hud.contentColor = .white
        hud.minSize = CGSize(width: 110, height: 110)
        hud.label.text = NSLocalizedString(msg, comment: "HUD loading title")
    }
    
    static public func hideLoading(from view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    static public func showToastHint(with msg: String = "", to view: UIView) {
        // 自定义成功时的View
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        let image = UIImage(named: "hudInfo")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        hud.customView = imageView
        hud.mode = .customView
        hud.bezelView.color = UIColor(white: 0, alpha: 0.7)
        hud.bezelView.blurEffectStyle = .regular
        hud.contentColor = .white
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.label.text = NSLocalizedString(msg, comment: "HUD completed title")
        hud.hide(animated: true, afterDelay: 2)
    }
    
    static public func showToastOnSuccess(with msg: String = "", to view: UIView) {
        // 自定义成功时的View
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        let image = UIImage(named: "hudSuccess")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        hud.customView = imageView
        hud.mode = .customView
        hud.bezelView.color = UIColor(white: 0, alpha: 0.7)
        hud.bezelView.blurEffectStyle = .regular
        hud.contentColor = .white
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.label.text = NSLocalizedString(msg, comment: "HUD completed title")
        hud.hide(animated: true, afterDelay: 2)
    }
    
    static public func showToastOnFail(with msg: String = "", to view: UIView) {
        // 自定义失败时的View
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        let image = UIImage(named: "hudError")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        hud.customView = imageView
        hud.mode = .customView
        hud.bezelView.color = UIColor(white: 0, alpha: 0.7)
        hud.bezelView.blurEffectStyle = .regular
        hud.contentColor = .white
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.label.text = NSLocalizedString(msg, comment: "HUD completed title")
        hud.hide(animated: true, afterDelay: 2)
    }
    
    static public func showToast(with msg: String, to view: UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.bezelView.color = UIColor(white: 0, alpha: 0.7)
        hud.bezelView.blurEffectStyle = .regular
        hud.contentColor = .white
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.label.text = NSLocalizedString(msg, comment: "HUD completed title")
        hud.hide(animated: true, afterDelay: 2)
    }
    
}
