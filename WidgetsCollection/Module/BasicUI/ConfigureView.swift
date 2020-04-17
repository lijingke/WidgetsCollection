//
//  ConfigureView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/15.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

protocol ConfigureViewDelegate: NSObjectProtocol {
    func valueChanged<T>(sender: T)
}

class ConfigureView: UIScrollView {
    
    @IBOutlet weak var showTakePhotoBtnSwitch: UISwitch!
    
    @IBOutlet weak var sortAscendingSwitch: UISwitch!
    
    @IBOutlet weak var allowPickingVideoSwitch: UISwitch!
    
    @IBOutlet weak var allowPickingOriginalPhotoSwitch: UISwitch!
    
    @IBOutlet weak var allowPickingImageSwitch: UISwitch!
    
    @IBOutlet weak var allowPickingGifSwitch: UISwitch!
    
    @IBOutlet weak var showSheetSwitch: UISwitch!
    
    @IBOutlet weak var maxCountTF: UITextField!
    
    @IBOutlet weak var columnNumberTF: UITextField!
    
    @IBOutlet weak var allowCropSwitch: UISwitch!
    
    @IBOutlet weak var allowPickingMuitlpleVideoSwitch: UISwitch!
    
    @IBOutlet weak var needCircleCropSwitch: UISwitch!
    
    @IBOutlet weak var showTakeVideoBtnSwitch: UISwitch!
    
    @IBOutlet weak var showSelectedIndexSwitch: UISwitch!
    
    weak var eventDelegate: ConfigureViewDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for subView in subviews[0].subviews {
            
            if let view = subView as? UISwitch {
                view.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
            }
            if let view = subView as? UITextField {
                view.addTarget(self, action: #selector(textFieldAction(sender:)), for: .valueChanged)
            }
        }
    }
        
    @objc private func switchAction(sender: UISwitch) {
        eventDelegate?.valueChanged(sender: sender)
    }
    
    @objc private func textFieldAction(sender: UITextField) {
        eventDelegate?.valueChanged(sender: sender)
    }
    
}
