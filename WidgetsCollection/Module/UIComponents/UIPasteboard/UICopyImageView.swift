//
//  UICopyImageView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/14.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class UICopyImageView: UIImageView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu(_:))))
    }
    
    @objc private func showMenu(_ sender: UILongPressGestureRecognizer) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: bounds)
        }
    }
    
    /// 复制
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.image = image
        let menu = UIMenuController.shared
        menu.hideMenu(from: self)
    }
    
    override func paste(_ sender: Any?) {
        let board = UIPasteboard.general
        self.image = board.image
        let menu = UIMenuController.shared
        menu.hideMenu(from: self)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        } else if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return true
        }
        return false
    }
}
