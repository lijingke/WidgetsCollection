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
        UIGraphicsBeginImageContext(self.contentSize)
        do {
            let oldOffset = self.contentOffset
            let oldFrame = self.frame
            
            self.contentOffset = .zero
            self.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: self.contentSize.width, height: self.contentSize.height), false, 0.0)
            
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            image = UIGraphicsGetImageFromCurrentImageContext()
            self.contentOffset = oldOffset
            self.frame = oldFrame
        }
        UIGraphicsEndImageContext()
        if image != nil {
            return image!
        }
        return nil
    }
}
