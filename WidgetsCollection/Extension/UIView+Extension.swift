//
//  UIView+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/6.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

extension UIView {
    func getFirstViewController() -> UIViewController?{
        
        for view in sequence(first: self.superview, next: {$0?.superview}){
            
            if let responder = view?.next{
                
                if responder.isKind(of: UIViewController.self){
                    
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
}

extension UIView {
    func getViewController() -> UIViewController {
        var responder = self.next
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
    
    var size:CGSize {
        get
        {
            return self.frame.size
        }
        set
        {
            self.frame.size = newValue
        }
    }
    
    var origin: CGPoint {
        get
        {
            return self.frame.origin
        }
        set
        {
            self.frame.origin = newValue
        }
    }
    
    
    var width:CGFloat {
        get
        {
            return self.size.width
        }
        set
        {
            self.size.width = newValue
        }
    }
    
    var height:CGFloat {
        get
        {
            return self.size.height
        }
        set
        {
            self.size.height = newValue
        }
    }
    
    var x:CGFloat {
        get
        {
            return self.origin.x
        }
        set
        {
            self.origin.x = newValue
        }
    }
    
    var y:CGFloat {
        get
        {
            return self.origin.y
        }
        set
        {
            self.origin.y = newValue
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
