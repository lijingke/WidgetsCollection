//
//  UIView+Gradient.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/26.
//
// UIView 渐变色 , UIView及其子类都可以使用，比如UIButton、UILabel等。
//
// Usage:
// myButton.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [UIColor(hex: "#FF2619").cgColor, UIColor(hex: "#FF8030").cgColor])

import UIKit

public extension UIView {
    // MARK: 添加渐变色图层

    func gradientColor(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [CGColor]) {
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
            return
        }

        // 外界如果改变了self的大小，需要先刷新
        layoutIfNeeded()

        var gradientLayer: CAGradientLayer!

        removeGradientLayer()

        gradientLayer = CAGradientLayer()
        gradientLayer.frame = layer.bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = true
        // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
        layer.insertSublayer(gradientLayer, at: 0)
        backgroundColor = UIColor.clear
        // self如果是UILabel，masksToBounds设为true会导致文字消失
        layer.masksToBounds = false
    }

    // MARK: 移除渐变图层

    // （当希望只使用backgroundColor的颜色时，需要先移除之前加过的渐变图层）
    func removeGradientLayer() {
        if let sl = layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}
