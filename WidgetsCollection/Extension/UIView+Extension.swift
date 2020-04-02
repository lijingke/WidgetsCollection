//
//  UIView+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/6.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

extension UIView {
    func getFirstViewController()->UIViewController?{
        
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
