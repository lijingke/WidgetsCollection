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
let kscreenHeight = UIScreen.main.bounds.height
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

let kWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
