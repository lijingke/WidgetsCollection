//
//  UIScrollView+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import UIKit

extension UIScrollView {
    var img: UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContext(contentSize)
        do {
            let oldOffset = contentOffset
            let oldFrame = frame

            contentOffset = .zero
            frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)

            UIGraphicsBeginImageContextWithOptions(CGSize(width: contentSize.width, height: contentSize.height), false, 0.0)

            layer.render(in: UIGraphicsGetCurrentContext()!)
            image = UIGraphicsGetImageFromCurrentImageContext()
            contentOffset = oldOffset
            frame = oldFrame
        }
        UIGraphicsEndImageContext()
        if image != nil {
            return image!
        }
        return nil
    }
}
