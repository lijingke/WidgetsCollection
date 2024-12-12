//
//  PopBubbleView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/12.
//

import Foundation
import UIKit

class PopBubbleView: UIView {
    var direction: PopMenueDirection
    var fillColor: UIColor
    init(direction: PopMenueDirection, fillColor: UIColor) {
        self.direction = direction
        self.fillColor = fillColor
        super.init(frame: .zero)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        if direction == PopMenueDirection.left {
            let startX = 20.0
            let startY = 8.0
            context.move(to: CGPoint(x: startX, y: startY)) // 起点
            context.addLine(to: CGPoint(x: startX + 5, y: startY - 8))
            context.addLine(to: CGPoint(x: startX + 10, y: startY))
        } else {
            let startX = frame.width - 20
            let startY = 8.0
            context.move(to: CGPoint(x: startX, y: startY)) // 起点
            context.addLine(to: CGPoint(x: startX + 5, y: startY - 8))
            context.addLine(to: CGPoint(x: startX + 10, y: startY))
        }
        context.closePath() // 结束
        fillColor.setFill() // 设置填充色
        fillColor.setStroke()
        context.drawPath(using: .fillStroke) // 绘制路径
    }
}
