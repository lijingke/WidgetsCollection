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
        playGround(rect)
    }

    func playGround(_ rect: CGRect) {
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
        let pentagonPointsArr = pentagonPoints(center: center, radius: radius)
        path3.move(to: pentagonPointsArr.first!)
        for i in 1..<pentagonPointsArr.count {
            let currentPoint = pentagonPointsArr[i]
            let previousPoint = pentagonPointsArr[i - 1]
            let controlPoint1 = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: previousPoint.y)
            let controlPoint2 = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: currentPoint.y)
//            path3.addCurve(to: currentPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
//            path3.addQuadCurve(to: currentPoint, controlPoint: controlPoint1)
            path3.addLine(to: pentagonPointsArr[i])
        }
//        path3.close()
        path3.stroke()

        // MARK: - 验证单条曲线

        // 创建贝塞尔路径
        let path4 = UIBezierPath()
        path4.lineWidth = 2.0
        path4.lineCapStyle = .round
        path4.lineJoinStyle = .round
        
        let pointsArr1 = [
            CGPoint(x: 70, y: 450),
            CGPoint(x: 170, y: 550),
        ]
        let pointsArr2 = [
            CGPoint(x: 220, y: 550),
            CGPoint(x: 320, y: 450),
        ]
        
        let allPoints = pointsArr1 + pointsArr2
        let minYPoint = allPoints.min(by: {$0.y < $1.y})
        
        // 绘制第一个贝塞尔曲线
        path4.move(to: pointsArr1.first!)
        for i in 1..<pointsArr1.count {
            let currentPoint = pointsArr1[i]
            let previousPoint = pointsArr1[i - 1]
            let controlPoint = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: previousPoint.y)
            path4.addQuadCurve(to: currentPoint, controlPoint: controlPoint)
        }

        // 绘制第二个贝塞尔曲线
//        path4.move(to: pointsArr2.first!)
        path4.addLine(to: pointsArr2.first!)
        for i in 1..<pointsArr2.count {
            let currentPoint = pointsArr2[i]
            let previousPoint = pointsArr2[i - 1]
            let controlPoint = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: previousPoint.y)
            path4.addQuadCurve(to: currentPoint, controlPoint: controlPoint)
        }
        
        
        // 创建渐变色
        let gradientColors = [
            UIColor(red: 1.0, green: 0.34, blue: 0.61, alpha: 0.3).cgColor, // 起始颜色
            UIColor(red: 1.0, green: 0.34, blue: 0.61, alpha: 0.0).cgColor // 结束颜色
        ]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: [0.0, 1.0])!

        // 创建一个新的上下文用于填充渐变
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        // 将路径添加到上下文以进行剪切
        context?.addPath(path4.cgPath)
        context?.addLine(to: CGPoint(x: pointsArr2.last!.x, y: rect.height)) // 形成底边
        context?.addLine(to: CGPoint(x: pointsArr1.first!.x, y: rect.height)) // 形成底边
        context?.closePath() // 关闭路径以填充
        
        let startPoint = CGPoint(x: rect.minX, y: minYPoint!.y) // 渐变从顶部
        let endPoint = CGPoint(x: rect.minX, y: rect.maxY-70)   // 渐变到底部 minY
        context?.clip() // 剪裁上下文仅限于曲线下方
        context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        // 恢复上下文状态
        context?.restoreGState()
        
        // 绘制曲线
        UIColor.systemCyan.setStroke()
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
