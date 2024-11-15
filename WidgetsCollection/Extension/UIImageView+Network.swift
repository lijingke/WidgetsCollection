//
//  UIImageView+Network.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import SDWebImage
import UIKit

extension UIImageView {
    /// 设置网络图片
    func setUrl(_ url: String?, placeholder: UIImage? = UIImage(named: "homepage_place")) {
        // 去掉前后空格，兼容安卓上传图片后可能存在前后空格的bug
        let urlString = (url ?? "").removeHeadAndTailSpace
        sd_setImage(with: URL(string: urlString), placeholderImage: placeholder)
    }

    /// 设置网络图片
    func setUrl(_ url: String?, _ place: String) {
        if url == nil || url!.count == 0 {
            image = UIImage(named: place)
            return
        }
        let tem = url ?? ""
        let urlStr = URL(string: tem)
        sd_setImage(with: urlStr, placeholderImage: UIImage(named: place))
    }

    /// 设置动画
    func setGif(data: NSData) {
        // 从data中读取数据: 将data转成CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        let imageCount = CGImageSourceGetCount(imageSource)

        // 便利所有的图片
        var images = [UIImage]()
        var totalDuration: TimeInterval = 0
        for i in 0..<imageCount {
            // .取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            if i == 0 {
                self.image = image
            }
            images.append(image)

            // 取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else { continue }
            guard let gifDict = (properties as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        // 设置imageView的属性
        animationImages = images
        animationDuration = totalDuration
        animationRepeatCount = 0
        // 开始播放
        startAnimating()
    }
}
