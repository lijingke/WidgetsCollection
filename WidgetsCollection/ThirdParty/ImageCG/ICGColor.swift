//
//  ICGColor.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/3.
//

import UIKit

public extension ImageCG where Base: UIColor {
    func image(_ size: CGSize) -> UIImage? {
        return drawImage(size: size) { context in
            context.setFillColor(base.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}

public extension ImageCG where Base == [UIColor] {
    enum Direction {
        case horizontal
        case vertical
        case diagonally
        
        fileprivate func point(_ size: CGSize) -> CGPoint {
            switch self {
            case .horizontal: return .init(x: size.width, y: 0)
            case .vertical: return .init(x: 0, y: size.height)
            case .diagonally: return .init(x: size.width, y: size.height)
            }
        }
    }
    
    /// Linear Gradient
    func linearGradient(_ size: CGSize, cornerRadius: CGFloat? = nil, locations: [CGFloat]? = nil, direction: Direction = .horizontal) -> UIImage? {
        return drawImage(size: size) { context in
            let colors: [CGColor] = base.map { $0.cgColor }
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: colors as CFArray, locations: locations)!
            
            if let cornerRadius = cornerRadius {
                let path = UIBezierPath(roundedRect: .init(origin: .zero, size: size), cornerRadius: cornerRadius)
                path.addClip()
            }
            
            context.drawLinearGradient(gradient,
                                       start: CGPoint(x: 0, y: 0),
                                       end: direction.point(size),
                                       options: .drawsBeforeStartLocation)
        }
    }
    
    /// Radial Gradient
    func radialGradient(_ size: CGSize, locations: [CGFloat]? = nil) -> UIImage? {
        return drawImage(size: size) { context in
            let colors: [CGColor] = base.map { $0.cgColor }
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: colors as CFArray, locations: locations)!
            
            let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            let radius: CGFloat = hypot(size.width, size.height) / 2.0
            context.drawRadialGradient(gradient,
                                       startCenter: center, startRadius: 0.0,
                                       endCenter: center, endRadius: radius,
                                       options: .drawsBeforeStartLocation)
        }
    }
}
