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
        initialized()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialized()
    }

    private func initialized() {
        subviews.last?.setValue(UIView(), forKey: "topLineOrFillView")
        for view in subviews {
            for subView in view.subviews {
                subView.backgroundColor = .clear
            }
        }
        layer.masksToBounds = true
        backgroundColor = .clear

        highlightedView.isUserInteractionEnabled = false
        highlightedView.frame = .zero
        highlightedView.backgroundColor = UIColor.clear
        highlightedView.layer.borderWidth = 1.0
        addSubview(highlightedView)
        highlightedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([highlightedView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     highlightedView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     highlightedView.heightAnchor.constraint(equalToConstant: 35),
                                     highlightedView.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let text = style?.pickerColor {
            switch text {
            case let .color(color):
                textColor = color
            case let .colors(colors):
                let colors = updateGradientToUIColor(colors: colors)
                textColor = colors ?? .black
            }
        }
    }
}

private extension LJKDatePicker {
    private func setupStyle() {
        if let minDate = style?.minimumDate {
            minimumDate = minDate
        }

        if let maxDate = style?.maximumDate {
            maximumDate = maxDate
        }

        if let color = style?.textColor {
            highlightedView.layer.borderColor = color.cgColor
        }
    }

    private func updateGradientToUIColor(colors: [UIColor]) -> UIColor? {
        let layer = createGradientLayer(colors: colors)
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
        layer.frame = bounds
        layer.colors = colors.map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.5)
        return layer
    }
}
