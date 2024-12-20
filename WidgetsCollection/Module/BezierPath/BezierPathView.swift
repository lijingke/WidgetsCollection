//
//  BezierPathView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/20.
//

import Foundation
import UIKit

class BezierPathView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        playGround()
    }

    func playGround() {
        // MARK: - 绘制空心长方形

        UIColor.systemMint.set()
        let path1 = UIBezierPath(rect: CGRect(x: 30, y: 50, width: 200, height: 100))
        path1.lineWidth = 5.0
        path1.lineCapStyle = .round
        path1.lineJoinStyle = .round
        path1.stroke()

        // MARK: - 绘制填充正方形

        UIColor.random.setFill()
        let path2 = UIBezierPath(rect: CGRect(x: 260, y: 50, width: 100, height: 100))
        path2.lineWidth = 5.0
        path2.lineCapStyle = .round
        path2.lineJoinStyle = .round
        path2.fill()

        // MARK: - 绘制正五边形

        UIColor.systemTeal.set()
        let path3 = UIBezierPath()
        path3.lineWidth = 5.0
        path3.lineCapStyle = .round
        path3.lineJoinStyle = .round
        let center = CGPoint(x: 195, y: 300)
        let radius: CGFloat = 100
        let pointsArr = pentagonPoints(center: center, radius: radius)
        path3.move(to: pointsArr.first!)
        for i in 1..<pointsArr.count {
            let currentPoint = pointsArr[i]
            let previousPoint = pointsArr[i - 1]
            let controlPoint1 = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: previousPoint.y)
            let controlPoint2 = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: currentPoint.y)
//            path3.addCurve(to: currentPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
//            path3.addQuadCurve(to: currentPoint, controlPoint: controlPoint1)
            path3.addLine(to: pointsArr[i])
        }
//        path3.close()
        path3.stroke()

        // MARK: - 验证单条曲线

        UIColor.systemCyan.set()
        let path4 = UIBezierPath()
        path4.lineWidth = 6.0
        path4.lineCapStyle = .round
        path4.lineJoinStyle = .round
        let pointsArr2 = [
            CGPoint(x: 100, y: 450),
            CGPoint(x: 200, y: 550),
        ]
        path4.move(to: pointsArr2.first!)
        for i in 1..<pointsArr2.count {
            let currentPoint = pointsArr2[i]
            let previousPoint = pointsArr2[i - 1]
            let controlPoint1 = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: previousPoint.y)
            let controlPoint2 = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: currentPoint.y)
//            path4.addCurve(to: currentPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            path4.addQuadCurve(to: currentPoint, controlPoint: controlPoint2)
            path4.addLine(to: pointsArr2[i])
        }
//        path4.close()
        path4.stroke()
    }

    /// 根据中心点获取正五边形五个顶点的坐标
    /// - Parameters:
    ///   - center: 中心点
    ///   - radius: 半径
    func pentagonPoints(center: CGPoint, radius: CGFloat) -> [CGPoint] {
        let angle = 2 * CGFloat.pi / 5
        var points: [CGPoint] = []
        for i in 0..<5 {
            let x = center.x + radius * cos(angle * CGFloat(i) - CGFloat.pi / 2)
            let y = center.y + radius * sin(angle * CGFloat(i) - CGFloat.pi / 2)
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
}
