//
//  LJKDatePicker.swift
//  DatePicker
//
//  Created by 李京珂 on 2024/11/27.
//

import Foundation
import UIKit

class LJKDatePicker: PIDatePicker {
    private var screenScale: CGFloat { UIScreen.main.scale }
    private let highlightedView: UIView = .init()
    
    var style: PickerStyle? { didSet { setupStyle() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialized()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialized()
    }
    
    private func initialized() {
        subviews.last?.setValue(UIView(), forKey: "topLineOrFillView")
        for view in self.subviews {
            for subView in view.subviews {
                subView.backgroundColor = .clear
            }
        }
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        
        self.highlightedView.isUserInteractionEnabled = false
        self.highlightedView.frame = .zero
        self.highlightedView.backgroundColor = UIColor.clear
        self.highlightedView.layer.borderWidth = 1.0
        self.addSubview(self.highlightedView)
        self.highlightedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.highlightedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     self.highlightedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     self.highlightedView.heightAnchor.constraint(equalToConstant: 35),
                                     self.highlightedView.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let text = style?.pickerColor {
            switch text {
            case .color(let color):
                self.textColor = color
            case .colors(let colors):
                let colors = updateGradientToUIColor(colors: colors)
                self.textColor = colors ?? .black
            }
        }
    }
}

private extension LJKDatePicker {
    private func setupStyle() {
        if let minDate = style?.minimumDate {
            self.minimumDate = minDate
        }
        
        if let maxDate = style?.maximumDate {
            self.maximumDate = maxDate
        }
        
        if let color = style?.textColor {
            self.highlightedView.layer.borderColor = color.cgColor
        }
    }
    
    private func updateGradientToUIColor(colors: [UIColor]) -> UIColor? {
        let layer = self.createGradientLayer(colors: colors)
        guard let image = updateGradientToUIImage(gradientLayer: layer) else { return nil }
        return UIColor(patternImage: image)
    }
    
    private func updateGradientToUIImage(gradientLayer: CAGradientLayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, gradientLayer.isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func createGradientLayer(colors: [UIColor]) -> CAGradientLayer {
        guard colors.count > 1 else { return CAGradientLayer() }
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = colors.map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.5)
        return layer
    }
}
