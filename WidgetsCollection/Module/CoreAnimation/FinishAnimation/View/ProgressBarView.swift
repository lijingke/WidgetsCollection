//
//  ProgressBarView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/8/25.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
    // MARK: Property
    var originFrame: CGRect
    var animating: Bool = false
    let progressBarHeight: CGFloat = 38
    let progressBarWidth: CGFloat = 150
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        originFrame = frame
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(tapped)
    }
    
    @objc private func tapped(_ sender: UITapGestureRecognizer) {
        self.frame = originFrame
        if animating == true {
            return
        }
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers {
                subLayer.removeFromSuperlayer()
            }
        }
        self.backgroundColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        animating = true
        self.layer.cornerRadius = self.progressBarHeight / 2
        let radiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        radiusAnimation.duration = 2
        radiusAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        radiusAnimation.fromValue = originFrame.size.height / 2
        radiusAnimation.delegate = self
        self.layer.add(radiusAnimation, forKey: "cornerRadiusShrinkAnim")
    }
    
    private func progressBarAnimation() {
        let progressLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.progressBarHeight / 2, y: self.progressBarHeight / 2))
        path.addLine(to: CGPoint(x: self.bounds.width - progressBarHeight / 2, y: self.bounds.height / 2))
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = progressBarHeight - 6
        progressLayer.lineCap = .round
        self.layer.addSublayer(progressLayer)
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2.0
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.delegate = self
        pathAnimation.setValue("progressBarAnimation", forKey: "animationName")
        progressLayer.add(pathAnimation, forKey: nil)
    }
}

// MARK: - CAAnimationDelegate
extension ProgressBarView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        print("started")
        if anim == self.layer.animation(forKey: "cornerRadiusShrinkAnim") {
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: {
                self.bounds = CGRect(x: 0, y: 0, width: self.progressBarWidth, height: self.progressBarHeight)
            }) { (finished) in
                self.layer.removeAllAnimations()
                /// 开启下一组动画
                self.progressBarAnimation()
            }
        }
        if anim == self.layer.animation(forKey: "cornerRadiusExpandAnim") {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                self.bounds = CGRect(x: 0, y: 0, width: self.originFrame.size.width/2, height: self.originFrame.size.width/2)
                self.backgroundColor = UIColor(red: 0.18038, green: 0.8, blue: 0.44313, alpha: 1.0)
            }) { (finished) in
                self.layer.removeAllAnimations()
                self.checkAnimation()
                self.animating = false
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("stopped")
        guard let subLayers = self.layer.sublayers, let animValue = anim.value(forKey: "animationName") as? String else {
            return
        }
        if animValue == "progressBarAnimation" {
            UIView.animate(withDuration: 0.3, animations: {
                for subLayer in subLayers {
                    subLayer.opacity = 0.0
                }
            }) { (finished) in
                for subLayer in subLayers {
                    subLayer.removeAllAnimations()
                }
                self.layer.cornerRadius = (self.originFrame.size.width / 2) / 2
                let radiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
                radiusAnimation.duration = 0.2
                radiusAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
                radiusAnimation.fromValue = self.progressBarHeight / 2
                radiusAnimation.delegate = self
                self.layer.add(radiusAnimation, forKey: "cornerRadiusExpandAnim")
            }
        }
    }
    
    private func checkAnimation() {
        let checkLayer = CAShapeLayer()
        let path = UIBezierPath()
        let bounds = self.bounds
        
        let dx = bounds.size.width * (1-1/CGFloat(sqrt(Float(2.0)))) / 2
        let dy = bounds.size.width * (1-1/CGFloat(sqrt(Float(2.0)))) / 2
        let rectInCircle = bounds.insetBy(dx: dx, dy: dy)
        print("rectInCircle === \(rectInCircle)")
        path.move(to: CGPoint(x: rectInCircle.origin.x + rectInCircle.size.width/9, y: rectInCircle.origin.y + rectInCircle.size.height*2/3))
        path.addLine(to: CGPoint(x: rectInCircle.origin.x + rectInCircle.size.width/3, y: rectInCircle.origin.y + rectInCircle.size.height*9/10))
        path.addLine(to: CGPoint(x: rectInCircle.origin.x + rectInCircle.size.width*8/10, y: rectInCircle.origin.y + rectInCircle.size.height*2/10))
        checkLayer.path = path.cgPath
        checkLayer.fillColor = UIColor.clear.cgColor
        checkLayer.strokeColor = UIColor.white.cgColor
        checkLayer.lineWidth = 10.0
        checkLayer.lineCap = .round
        checkLayer.lineJoin = .round
        self.layer.addSublayer(checkLayer)
        let checkAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        checkAnimation.duration = 0.3
        checkAnimation.fromValue = 0.0
        checkAnimation.delegate = self
        checkAnimation.setValue("checkAnimation", forKey: "animationName")
        checkLayer.add(checkAnimation, forKey: nil)
    }
}
