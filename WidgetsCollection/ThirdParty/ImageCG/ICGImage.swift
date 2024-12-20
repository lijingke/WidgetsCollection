//
//  ICGImage.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/3.
//

import CoreGraphics
import UIKit

public extension ImageCG where Base: UIImage {
    enum Position {
        case center
    }

    func add(_ logoImage: UIImage, position _: ImageCG.Position = .center) -> UIImage? {
        return drawImage(size: base.size) { _ in
            let x = (base.size.width - logoImage.size.width) / 2.0
            let y = (base.size.height - logoImage.size.height) / 2.0

            base.draw(in: .init(origin: .zero, size: base.size))
            logoImage.draw(in: .init(origin: .init(x: x, y: y), size: logoImage.size))
        }
    }

    func add(_ logoImageName: String, position: ImageCG.Position = .center) -> UIImage? {
        return add(UIImage(named: logoImageName)!, position: position)
    }

    /// 缩放到指定大小
    func zoom(to size: CGSize) -> UIImage? {
        return drawImage(size: size) { _ in
            base.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    /// 裁剪
    func clip(in rect: CGRect) -> UIImage? {
        guard let subImage = base.cgImage?.cropping(to: rect.pixel(base.scale)) else { return nil }
        return UIImage(cgImage: subImage, scale: base.scale, orientation: .up)
    }

    /// to UIColor
    var color: UIColor? {
        UIColor(patternImage: base)
    }

    /// UIImage 并转为 PDF
    /// - Parameters:
    ///   - filePath: PDF 路径
    func savedPDF(to filePath: String) {
        let rect = CGRect(origin: .zero, size: base.size)
        UIGraphicsBeginPDFContextToFile(filePath, rect, nil)
        UIGraphicsBeginPDFPage()
        base.draw(in: rect)
        UIGraphicsEndPDFContext()
    }

    /// 读取 PDF 并转为 UIImage
    /// - Parameters:
    ///   - filePath: PDF 路径
    ///   - isJoin: 是否进行拼接，ture = 拼接成一张图片，false = 一页一张图片
    ///   - color: 填充背景颜色
    /// - Returns: 数组 [UIImage]
    static func readPDF(from filePath: String, isJoin: Bool = true, fill color: UIColor = .white) -> [UIImage] {
        let data = readPDF(from: filePath, fill: color)
        guard isJoin else { return data.0 }
        return [pdfJoin(from: data)]
    }

    internal static func pdfJoin(from data: ([UIImage], CGSize)) -> UIImage {
        return (drawImage(size: data.1, isOpaque: true) { _ in
            var offsetY: CGFloat = 0.0
            for image in data.0 {
                let scale = image.size.width / UIScreen.main.bounds.width
                let width = image.size.width / scale
                let height = image.size.height / scale
                image.draw(in: CGRect(origin: .init(x: 0, y: offsetY), size: .init(width: width, height: height)))
                offsetY += height
            }
        })!
    }

    internal static func readPDF(from filePath: String, fill color: UIColor = .white) -> ([UIImage], CGSize) {
        guard let pdf = CGPDFDocument(URL(fileURLWithPath: filePath) as CFURL) else { return ([], .zero) }

        var images: [UIImage] = []
        let pageRect: CGRect = pdf.page(at: 1)!.getBoxRect(.mediaBox)

        _ = drawImage(size: pageRect.size, isOpaque: true) { context in
            for index in 1 ... pdf.numberOfPages {
                context.saveGState()
                color.setFill()
                context.fill(CGRect(origin: .zero, size: pageRect.size))

                let pdfPage: CGPDFPage = pdf.page(at: index)!
                context.translateBy(x: 0.0, y: pageRect.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
                context.drawPDFPage(pdfPage)
                images.append(UIGraphicsGetImageFromCurrentImageContext()!)
                context.clear(pageRect)
                context.restoreGState()
            }
        }

        let scale = pageRect.size.width / UIScreen.main.bounds.width
        return (images, CGSize(width: pageRect.size.width / scale, height: pageRect.size.height * CGFloat(pdf.numberOfPages) / scale))
    }
}

extension CGRect {
    func pixel(_ scale: CGFloat) -> CGRect {
        return .init(x: origin.x * scale,
                     y: origin.y * scale,
                     width: size.width * scale,
                     height: size.height * scale)
    }
}
