//
//  AppInfoModel.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

struct AppInfoModel {
    /// 年龄分级
    var advisories: [String]?
    /// Apple TV 预览
    var appletvScreenshotUrls: [String]?
    /// 开发者Id
    var artistId: Int?
    /// 应用名
    var artistName: String?
    /// 开发者应用页
    var artistViewUrl: String?
    /// 应用图标，尺寸为100x100
    var artworkUrl100: String?
    /// 应用图标，尺寸为512x512
    var artworkUrl512: String?
    /// 应用图标，尺寸为60x60
    var artworkUrl60: String?
    /// 应用总的平均分
    var averageUserRating: Double?
    /// 应用当前版本的平均分
    var averageUserRatingForCurrentVersion: Double?
    /// bundleId
    var bundleId: String?
    /// 年龄分级
    var contentAdvisoryRating: String?
    /// 货币单位
    var currency: String?
    /// 当前版本发布时间
    var currentVersionReleaseDate: String?
    /// 应用描述
    var description: String?
    /// 特性
    var features: [String]?
    /// 应用大小
    var fileSizeBytes: String?
    /// 应用价格
    var formattedPrice: String?
    /// 分类Id
    var genreIds: [String]?
    /// 应用分类
    var genres: [String]?
    /// iPad预览图
    var ipadScreenshotUrls: [String]?
    /// 是否支持游戏中心
    var isGameCenterEnabled: Bool?
    /// 是否支持批量购买
    var isVppDeviceBasedLicensingEnabled: Bool?
    /// iTunes种类
    var kind: String?
    /// 语言
    var languageCodesISO2A: [String]?
    /// 系统要求
    var minimumOsVersion: String?
    /// 价格
    var price: Float?
    /// 主分类Id
    var primaryGenreId: Int?
    /// 主分类名
    var primaryGenreName: String?
    /// 发布时间
    var releaseDate: String?
    /// 更新日志
    var releaseNotes: String?
    /// 预览
    var screenshotUrls: [String]?
    /// 开发者名称
    var sellerName: String?
    /// 开发者网站
    var sellerUrl: String?
    /// 兼容性
    var supportedDevices: [String]?
    /// 审查名称
    var trackCensoredName: String?
    /// 评级
    var trackContentRating: String?
    /// 应用程序ID
    var trackId: Int?
    /// 应用程序名称
    var trackName: String?
    /// 应用程序介绍网址
    var trackViewUrl: String?
    /// 用户评级
    var userRatingCount: Int?
    /// 当前评分
    var userRatingCountForCurrentVersion: Int?
    /// 版本号
    var version: String?
    /// 类型，图书或应用
    var wrapperType: String?
}
