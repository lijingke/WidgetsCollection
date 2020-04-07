//
//  NumberButton.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/3.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class NumberButton: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.hexStringToColor(hexString: ColorOfWaveBlackColor).cgColor
        layer.borderWidth = 5.0
        layer.cornerRadius = self.width * 0.5
        layer.masksToBounds = true
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
