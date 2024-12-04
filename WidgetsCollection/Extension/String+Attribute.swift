//
//  String+Attribute.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/28.
//

import Foundation

extension String {
    /**
     若字符串存在<img>，必须传入font
     */
    func attributedString(font: UIFont? = nil) -> NSAttributedString {
        var tempString = self
        var startIndex = tempString.startIndex
        let attrStr = NSMutableAttributedString(string: self)
        if font != nil {
            let imgPrefix = "<img="
            let imgSuffix = ">"
            while startIndex < tempString.endIndex {
                if let prefixRange = tempString.range(of: imgPrefix, range: Range(uncheckedBounds: (lower: startIndex, upper: tempString.endIndex))) {
                    if let suffixRange = tempString.range(of: imgSuffix, range: Range(uncheckedBounds: (lower: prefixRange.upperBound, upper: tempString.endIndex))) {
                        let imgName = String(tempString[prefixRange.upperBound ... tempString.index(before: suffixRange.lowerBound)])
                        let img = UIImage(named: imgName)!
                        let attachment = NSTextAttachment(image: img)
                        let imgH = img.size.height
                        let imgW = img.size.width
                        let imgStr = NSMutableAttributedString(attachment: attachment)
                        let imageOffset = (font!.capHeight - imgH) / 2.0
                        let imgRect = CGRect(x: 0, y: imageOffset, width: imgW, height: imgH)
                        attachment.bounds = imgRect
                        let replacement = imgPrefix + imgName + imgSuffix
                        let range = attrStr.mutableString.range(of: replacement)
                        if range.location != NSNotFound {
                            attrStr.replaceCharacters(in: range, with: "")
                        }
                        attrStr.insert(imgStr, at: tempString.distance(from: tempString.startIndex, to: prefixRange.lowerBound))
                        tempString = attrStr.mutableString.copy() as! String
                        startIndex = prefixRange.lowerBound
                    } else {
                        break
                    }
                } else {
                    break
                }
            }
            tempString = attrStr.mutableString.copy() as! String
        }
        let prefix = "<attr"
        let prefixClose = ">"
        let suffix = "</attr>"
        let colorPrefix = "color="
        let fontPrefix = "font="
        var deleteRanges = [Any]()
        startIndex = tempString.startIndex
        while startIndex < tempString.endIndex {
            if let prefixRange = tempString.range(of: prefix, range: Range(uncheckedBounds: (lower: startIndex, upper: tempString.endIndex))) {
                let prefixStartIndex = prefixRange.lowerBound
                let prefixEndIndex = tempString.index(after: prefixRange.upperBound)
                if let prefixCloseRange = tempString.range(of: prefixClose, range: Range(uncheckedBounds: (lower: startIndex, upper: tempString.endIndex))) {
                    let prefixCloseStartIndex = prefixCloseRange.lowerBound
                    let prefixCloseEndIndex = prefixCloseRange.upperBound
                    if let suffixRange = tempString.range(of: suffix, range: Range(uncheckedBounds: (lower: prefixEndIndex, upper: tempString.endIndex))) {
                        let suffixStartIndex = suffixRange.lowerBound
                        let suffixEndIndex = suffixRange.upperBound
                        var colorValue: String?
                        if let colorRange = tempString.range(of: colorPrefix, range: Range(uncheckedBounds: (lower: prefixEndIndex, upper: prefixCloseStartIndex))) {
                            if let spaceRange = tempString.range(of: " ", range: Range(uncheckedBounds: (lower: colorRange.upperBound, upper: prefixCloseStartIndex))) {
                                colorValue = String(tempString[colorRange.upperBound ... tempString.index(before: spaceRange.lowerBound)])
                            } else {
                                colorValue = String(tempString[colorRange.upperBound ... tempString.index(before: prefixCloseStartIndex)])
                            }
                        }
                        var fontValue: String?
                        if let fontRange = tempString.range(of: fontPrefix, range: Range(uncheckedBounds: (lower: prefixEndIndex, upper: prefixCloseStartIndex))) {
                            if let spaceRange = tempString.range(of: " ", range: Range(uncheckedBounds: (lower: fontRange.upperBound, upper: prefixCloseStartIndex))) {
                                fontValue = String(tempString[fontRange.upperBound ... tempString.index(before: spaceRange.lowerBound)])
                            } else {
                                fontValue = String(tempString[fontRange.upperBound ... tempString.index(before: prefixCloseStartIndex)])
                            }
                        }
                        let contentRange = Range(uncheckedBounds: (lower: prefixCloseEndIndex, upper: suffixStartIndex))
                        if colorValue != nil {
                            attrStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: colorValue ?? "")], range: NSRange(contentRange, in: tempString))
                        }
                        if fontValue != nil {
                            var fontSize = 0.0
                            if fontValue!.starts(with: "N") {
                                fontSize = fontValue!.substring(from: 1, len: fontValue!.count - 1).toCGFloat()!
                                attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], range: NSRange(contentRange, in: tempString))
                            } else {
                                fontSize = fontValue!.toCGFloat()!
                                attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], range: NSRange(contentRange, in: tempString))
                            }
                        }
                        deleteRanges.append(Range(uncheckedBounds: (lower: prefixStartIndex, upper: prefixCloseEndIndex)))
                        deleteRanges.append(Range(uncheckedBounds: (lower: suffixStartIndex, upper: suffixEndIndex)))
                        startIndex = suffixRange.upperBound
                    } else {
                        break
                    }
                } else {
                    break
                }
            } else {
                break
            }
        }
        deleteRanges.reverse()
        for v in deleteRanges {
            var range = v as! Range<String.Index>
            range = Range(uncheckedBounds: (lower: tempString.index(range.lowerBound, offsetBy: 0), upper: tempString.index(range.upperBound, offsetBy: 0)))
            let nsRange = NSRange(range, in: tempString)
            let composedRange = (attrStr.string as NSString).rangeOfComposedCharacterSequences(for: nsRange)
            attrStr.deleteCharacters(in: composedRange)
        }
        return attrStr
    }

    func toCGFloat() -> CGFloat? {
        return Double(self).map { v in
            CGFloat(v)
        }
    }

    func substring(from: Int, len: Int) -> String {
        if len <= 0 {
            return ""
        }
        if let startIdx = index(startIndex, offsetBy: from, limitedBy: endIndex) {
            if let endIdx = index(startIdx, offsetBy: len, limitedBy: endIndex) {
                return String(self[startIdx ..< endIdx])
            }
        }
        return ""
    }
}
