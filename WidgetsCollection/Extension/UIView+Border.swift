//
//  UIView+Border.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import UIKit

public extension UIView {
    // 画线
    private func drawBorder(rect: CGRect, color: UIColor) {
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        self.layer.addSublayer(lineShape)
    }
    
    // 设置上边框
    func topBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.drawBorder(rect: rect, color: borderColor)
    }
    
    // 设置右边框
    func rightBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: self.frame.size.width - width, width: width, height: self.frame.size.height)
        self.drawBorder(rect: rect, color: borderColor)
    }
    
    // 设置左边框
    func leftBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.drawBorder(rect: rect, color: borderColor)
    }
    
    // 设置底边框
    func bottomBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.drawBorder(rect: rect, color: borderColor)
    }
}
