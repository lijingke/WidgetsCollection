//
//  Const.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/3.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

// MARK: - Color

let ColorOfBlueColor = "#3DA3E1"
let ColorOfBlackColor = "#000000"
let ColorOfWaveBlueColor = "#44B7FC"
let ColorOfWaveBlackColor = "#4F4F4F"

// MARK: - 坐标

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kStatusBarHeight = UIApplication.shared.statusBarFrame.height
let kNaviHeight = CGFloat(44)
let kTopHeight = kStatusBarHeight + kNaviHeight
let kThemeColor = UIColor(hexString: "#0A75D8")

// MARK: - 项目相关

let projectName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""

// MARK: - Net

let SMDomainURL = "https://sm.ms/api/v2/"
let TokenAPI = "token"
let UploadHistoryAPI = "upload_history"
let ProfileAPI = "profile"
let UploadAPI = "upload"

var kWindow: UIWindow? {
    if #available(iOS 15.0, *) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        var window = scene.keyWindow
        if window == nil {
            window = scene.windows.first { $0.isKeyWindow }
        }
        return window
    } else {
        return UIApplication.shared.keyWindow
    }
}
