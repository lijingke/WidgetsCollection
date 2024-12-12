//
//  PopBubbleView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/12.
//

import Foundation
import UIKit

class PopBubbleView: UIView {
    
    var direction: POPMenueDirection
    var orign: CGPoint
    var fillColor: UIColor
    init(direction: POPMenueDirection, orign: CGPoint, fillColor: UIColor) {
        self.direction = direction
        self.orign = orign
        self.fillColor = fillColor
        super.init(frame: .zero)
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        if direction == POPMenueDirection.left {
            let startX = orign.x + 20
            let startY = orign.y
            context.move(to: CGPoint(x: startX, y: startY)) // 起点
            context.addLine(to: CGPoint(x: startX + 5, y: startY - 8))
            context.addLine(to: CGPoint(x: startX + 10, y: startY))
        } else {
            let startX = orign.x + 50
            let startY = orign.y + 50
            context.move(to: CGPoint(x: startX, y: startY)) // 起点
            context.addLine(to: CGPoint(x: startX + 5, y: startY - 8))
            context.addLine(to: CGPoint(x: startX + 10, y: startY))
        }
        context.closePath() // 结束
        UIColor.white.setFill() // 设置填充色
        UIColor.white.setStroke()
        context.drawPath(using: .fillStroke) // 绘制路径
    }
}
