//
//  UICollectionViewFlowLayout+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import UIKit

class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    // 这个函数没有做什么事情，主要是调用做事情的函数 layoutAttributesForItem，获取信息，提供出去
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesCopy: [UICollectionViewLayoutAttributes] = []
        if let attributes = super.layoutAttributesForElements(in: rect) {
            attributes.forEach { attributesCopy.append($0.copy() as! UICollectionViewLayoutAttributes) }
        }

        for attributes in attributesCopy {
            if attributes.representedElementKind == nil {
                let indexpath = attributes.indexPath
                if let attr = layoutAttributesForItem(at: indexpath) {
                    attributes.frame = attr.frame
                }
            }
        }
        return attributesCopy
    }

    // 这个函数里面，具体处理了固定行距列表左排的布局
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let currentItemAttributes = super.layoutAttributesForItem(at: indexPath as IndexPath)?.copy() as? UICollectionViewLayoutAttributes, let collection = collectionView {
            let sectionInset = evaluatedSectionInsetForItem(at: indexPath.section)
            let isFirstItemInSection = indexPath.item == 0
            let layoutWidth = collection.frame.width - sectionInset.left - sectionInset.right

            // 让每一行的第一个元素排头，分两种情况处理。这是第一种，这个 section 的第一个元素，自然是排头。
            guard !isFirstItemInSection else {
                currentItemAttributes.leftAlignFrame(with: sectionInset)
                return currentItemAttributes
            }

            let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)

            let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? CGRect.zero
            let previousFrameRightPoint = previousFrame.origin.x + previousFrame.width
            let currentFrame = currentItemAttributes.frame
            let strecthedCurrentFrame = CGRect(x: sectionInset.left,
                                               y: currentFrame.origin.y,
                                               width: layoutWidth,
                                               height: currentFrame.size.height)
            // if the current frame, once left aligned to the left and stretched to the full collection view
            // widht intersects the previous frame then they are on the same line
            let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)

            // 让每一行的第一个元素排头，分两种情况处理。这是第二种，这个 section 的其他的排头，算出来，就是：上一个格子在上一行，不在当前行，
            guard !isFirstItemInRow else {
                // make sure the first item on a line is left aligned
                currentItemAttributes.leftAlignFrame(with: sectionInset)
                return currentItemAttributes
            }

            //  剩下的，简单了。统一处理掉。 剩下的格子都不是排头，与上一个固定间距完了。
            var frame = currentItemAttributes.frame
            frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacing(at: indexPath.section)
            currentItemAttributes.frame = frame
            return currentItemAttributes
        }
        return nil
    }

    // 获取设置的最小水平间距
    func evaluatedMinimumInteritemSpacing(at sectionIndex: Int) -> CGFloat {
        if let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout, let collection = collectionView {
            let inteitemSpacing = delegate.collectionView?(collection, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
            if let inteitemSpacing = inteitemSpacing {
                return inteitemSpacing
            }
        }
        return minimumInteritemSpacing
    }

    func evaluatedSectionInsetForItem(at index: Int) -> UIEdgeInsets {
        if let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout, let collection = collectionView {
            let insetForSection = delegate.collectionView?(collection, layout: self, insetForSectionAt: index)
            if let insetForSectionAt = insetForSection {
                return insetForSectionAt
            }
        }
        return sectionInset
    }
}

extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(with sectionInset: UIEdgeInsets) {
        var tempFrame = frame
        tempFrame.origin.x = sectionInset.left
        frame = tempFrame
    }
}
