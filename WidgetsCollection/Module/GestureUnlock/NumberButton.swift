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
        layer.cornerRadius = width * 0.5
        layer.masksToBounds = true
        isUserInteractionEnabled = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
