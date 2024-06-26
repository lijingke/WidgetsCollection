//
//  UICollectionViewCell+Shadow.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/27.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func setShadow() {
//        contentView.layer.cornerRadius = 10
//        contentView.layer.borderWidth = 1.0

        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor(hexString: "#000000", withAlpha: 0.09).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 13.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
