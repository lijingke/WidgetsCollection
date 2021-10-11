//
//  UIView+Layer.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import UIKit

extension UIView {
    /// 圆角
    func circular() {
        self.layer.cornerRadius = self.height * 0.5
        self.layer.masksToBounds = true
    }
    
    /// 设置边框
    func borderSet(_ color: UIColor, _ width: Double) {
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.cgColor
    }
    
    /// 5圆角
    func circular5() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    /// 阴影
    func setShadowColor(colorW: CGFloat) {
        self.setShadowBy(color: UIColor.black, w: colorW)
    }
    
    /// 阴影2
    func setShadowBy(color: UIColor, w: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: w, height: w)
    }
    
    /// 设置圆角
    func circular(_ height: CGFloat) {
        self.layer.cornerRadius = height
        self.layer.masksToBounds = true
    }
    
    // MARK: - 绘制虚线

    func addDashLine(color: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        
        shapeLayer.position = CGPoint(x: self.frame.width / 2, y: 0)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 0.5 // 线条高度
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        // 跳动评率
        shapeLayer.lineDashPattern = [NSNumber(value: 8), NSNumber(value: 5)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
    
    /// 旋转
    @objc func rotate() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1.6
        rotationAnimation.isCumulative = true // 旋转累加角度
        rotationAnimation.repeatCount = 100000 // 旋转次数
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// 停止旋转
    @objc func stopRotate() {
        layer.removeAllAnimations()
    }
    
    /// 截屏
    func getImg() -> UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContext(self.size)
        do {
            UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        if image != nil {
            return image!
        }
        return nil
    }
    
    func cornerWithRadius(redius: CGFloat) {
        self.cornerWithRadiusrectCornerType(radius: redius, rectCornerType: UIRectCorner.allCorners)
    }
    
    func cornerWithRadiusrectCornerType(radius: CGFloat, rectCornerType: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCornerType, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func addCorner(conrners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
