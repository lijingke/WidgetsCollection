//
//  ImageChooseConf.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/22.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

public struct ImageChooseConf {
    /// 是否允许拍照
    public var showTakePhotoBtn: Bool = true
    /// 照片是否按修改时间升序排列
    public var sortAscending: Bool = true
    /// 是否允许选择视频
    public var allowPickingVideo: Bool = true
    /// 是否允许选择照片原图
    public var allowPickingOriginalPhoto: Bool = true
    /// 是否允许选择照片
    public var allowPickingImage: Bool = true
    /// 是否允许选择Gif图片
    public var allowPickingGif: Bool = false
    /// 把照片/拍视频按钮放在外面
    public var showSheet: Bool = false
    /// 照片最大可选张数
    public var maxCount: Int = 9
    /// 每行展示照片张数
    public var columnNumber: Int = 4
    /// 单选模式下是否允许裁剪
    public var allowCrop: Bool = false
    /// 是否允许多选视频/GIF/图片
    public var allowPickingMuitlpleVideo: Bool = false
    /// 是否使用圆形裁剪框
    public var needCircleCrop: Bool = false
    /// 是否允许拍视频
    public var showTakeVideoBtn: Bool = true
    /// 是否在右上角显示图片选中序号
    public var showSelectedIndex: Bool = true
}
