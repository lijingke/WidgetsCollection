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
