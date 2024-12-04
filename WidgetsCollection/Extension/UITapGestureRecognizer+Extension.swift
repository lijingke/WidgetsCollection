//
//  UITapGestureRecognizer+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/4.
//

import Foundation
import UIKit

@objc public extension UITapGestureRecognizer {
    func didTapLabelAttributedText(_ linkDic: [String: String], action: @escaping (String, String?) -> Void) {
        assert((view as? UILabel) != nil, "Only supports UILabel")
        guard let label = view as? UILabel,
              let attributedText = label.attributedText
        else { return }

        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText)
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines

        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        for e in linkDic {
            let targetRange: NSRange = (attributedText.string as NSString).range(of: e.key)
            let isContain = NSLocationInRange(indexOfCharacter, targetRange)
            if isContain {
                action(e.key, e.value)
            }
        }
    }
}
