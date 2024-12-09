//
//  UIDatePicker+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/9.
//

import Foundation

// MARK: - UIDatePicker Extension

@available(iOS 14.0, *)
extension UIDatePicker {
    func setOnDateChangeListener(onDateChanged: @escaping () -> Void) {
        self.addAction(UIAction { _ in
            onDateChanged()
        }, for: .valueChanged)
    }
}
