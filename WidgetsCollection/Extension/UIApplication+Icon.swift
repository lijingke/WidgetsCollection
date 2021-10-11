//
//  UIApplication+Icon.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import UIKit

extension UIApplication {
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
              let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
              // First will be smallest for the device class, last will be the largest for device class
              let lastIcon = iconFiles.lastObject as? String,
              let icon = UIImage(named: lastIcon)
        else {
            return nil
        }
        return icon
    }
}
