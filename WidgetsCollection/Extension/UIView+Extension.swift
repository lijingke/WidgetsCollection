//
//  UIView+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/6.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

extension UIView {
    func getFirstViewController() -> UIViewController? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}

extension UIView {
    func getViewController() -> UIViewController {
        var responder = next
        let b = true

        while b {
            if (responder?.isKind(of: UIViewController.self))! {
                return responder as! UIViewController
            } else {
                responder = responder?.next
            }
        }
    }
}

extension UIView {
    func setShadow(color: UIColor, radius: CGFloat, offset: CGSize) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = 1
        layer.shadowRadius = radius
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if bounds == .zero {
            return
        }
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.mask = rectShape
    }
    
    func screenCoordinates() -> CGRect? {
        guard let rootView = UIApplication.shared.windows.first(where: \.isKeyWindow) else {
            return nil
        }
        
        let viewFrameInWindow = self.convert(self.bounds, to: nil)
        let viewFrameInScreen = rootView.convert(viewFrameInWindow, to: nil)
        
        return viewFrameInScreen
    }
}


extension UIView {
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }

    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }

    var width: CGFloat {
        get {
            return size.width
        }
        set {
            size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            return size.height
        }
        set {
            size.height = newValue
        }
    }

    var x: CGFloat {
        get {
            return origin.x
        }
        set {
            origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin.y = newValue
        }
    }
}

/// 添加多个子视图
public extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { self.addSubview($0) }
    }

    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

/// 获取父控制器
public extension UIView {
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

/// 第一响应者
public extension UIView {
    func firstResponder() -> UIView? {
        var views = [UIView](arrayLiteral: self)
        var i = 0
        repeat {
            let view = views[i]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            i += 1
        } while i < views.count
        return nil
    }
}
