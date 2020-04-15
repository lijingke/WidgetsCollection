//
//  ConfigureView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/15.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
