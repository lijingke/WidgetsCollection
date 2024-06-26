//
//  UILabel+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import Foundation

public extension UILabel {
    func getLinesArrayOfString() -> [String]? {
        let text = self.text
        let font = self.font
        let rect = self.frame

        let myFont = CTFontCreateWithName(((font?.fontName) as CFString?)!, font!.pointSize, nil)
        let attStr = NSMutableAttributedString(string: text ?? "")
        attStr.addAttribute(NSAttributedString.Key(kCTFontAttributeName as String), value: myFont, range: NSRange(location: 0, length: attStr.length))
        let frameSetter = CTFramesetterCreateWithAttributedString(attStr)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: 100_000), transform: .identity)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame) as? [AnyHashable]
        var linesArray: [AnyHashable] = []
        for line in lines ?? [] {
            let lineRef = line
            let lineRange = CTLineGetStringRange(lineRef as! CTLine)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString = (text as NSString?)?.substring(with: range)
            CFAttributedStringSetAttribute(attStr as CFMutableAttributedString, lineRange, kCTKernAttributeName, NSNumber(value: 0.0))
            CFAttributedStringSetAttribute(attStr as CFMutableAttributedString, lineRange, kCTKernAttributeName, NSNumber(value: 0.0))
            linesArray.append(lineString ?? "")
        }
        return linesArray as? [String]
    }
}

public extension UILabel {
    /**
     The content size of UILabel

     - returns: CGSize
     */
    func contentSize() -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = textAlignment
        let attributes: [NSAttributedString.Key: AnyObject] = [
            .font: font,
            .paragraphStyle: paragraphStyle,
        ]
        let contentSize: CGSize = text!.boundingRect(
            with: frame.size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        ).size
        return contentSize
    }
}
