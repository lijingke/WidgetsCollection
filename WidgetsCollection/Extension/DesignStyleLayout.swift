//
//  DesignStyleLayout.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/29.
//

import UIKit

extension Int {
    func isEven() -> Bool {
        return self % 2 == 0
    }

    func isOdd() -> Bool {
        return self % 2 != 0
    }
}

/**
 * 这个类只简单定义了一个section的布局
 */
class DesignStyleLayout: UICollectionViewFlowLayout {
    // 内容区域总大小，不是可见区域
    override var collectionViewContentSize: CGSize {
        let width = collectionView!.bounds.size.width - collectionView!.contentInset.left
            - collectionView!.contentInset.right
        // 单元格边长
        let unitWidth = width / 3
        // 当前行数，每行显示3个图片，1大2小或者3小
        let itemCount = Double(collectionView?.numberOfItems(inSection: 0) ?? 0)
        let line = Int(ceil(Double(itemCount / 3.0)))
        // 当前行的Y坐标
        let oneGroupHeight = CGFloat(line / 2) * (3.0 * unitWidth)
        var remainHeight: CGFloat = 0
        if line.isOdd() {
            if (line + 1) % 4 == 0 {
                if Int(itemCount) % 3 == 1 {
                    remainHeight = unitWidth
                } else {
                    remainHeight = 2 * unitWidth
                }
            } else {
                remainHeight = 2 * unitWidth
            }
        } else {
            remainHeight = unitWidth
        }

        let remainLineHeights = CGFloat(line % 2) * remainHeight
        let height = oneGroupHeight + remainLineHeights
        return CGSize(width: width, height: height)
    }

    // 所有单元格位置属性
    override func layoutAttributesForElements(in _: CGRect)
        -> [UICollectionViewLayoutAttributes]?
    {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        let cellCount = collectionView!.numberOfItems(inSection: 0)
        for i in 0 ..< cellCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = layoutAttributesForItem(at: indexPath)
            attributesArray.append(attributes!)
        }
        return attributesArray
    }

    // 这个方法返回每个单元格的位置和大小
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes?
    {
        // 当前单元格布局属性
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        // 单元格边长
        let unitWidth = collectionViewContentSize.width / 3
        // 当前行数，每行显示3个图片，1大2小或者3小
        let line: Int = indexPath.item / 3
        // 当前行的Y坐标
        let oneGroupHeight = CGFloat(line / 2) * (3.0 * unitWidth)
        let remainHeight = CGFloat(line % 2) * (2 * unitWidth)
        let lineOriginY = oneGroupHeight + remainHeight

        switch indexPath.item % 12 {
        case 0:
            attribute.frame = CGRect(x: 0,
                                     y: lineOriginY,
                                     width: unitWidth * 2,
                                     height: unitWidth * 2)
        case 1:
            attribute.frame = CGRect(x: unitWidth * 2,
                                     y: lineOriginY,
                                     width: unitWidth,
                                     height: unitWidth)
        case 2:
            attribute.frame = CGRect(x: unitWidth * 2,
                                     y: lineOriginY + unitWidth,
                                     width: unitWidth,
                                     height: unitWidth)
        case 3:
            attribute.frame = CGRect(x: 0,
                                     y: lineOriginY,
                                     width: unitWidth,
                                     height: unitWidth)
        case 4:
            attribute.frame = CGRect(x: unitWidth,
                                     y: lineOriginY,
                                     width: unitWidth,
                                     height: unitWidth)
        case 5:

            attribute.frame = CGRect(x: unitWidth * 2,
                                     y: lineOriginY,
                                     width: unitWidth,
                                     height: unitWidth)
        case 6:
            attribute.frame = CGRect(x: 0,
                                     y: lineOriginY,
                                     width: unitWidth,
                                     height: unitWidth)
        case 7:
            attribute.frame = CGRect(x: unitWidth,
                                     y: lineOriginY,
                                     width: unitWidth * 2,
                                     height: unitWidth * 2)
        case 8:
            attribute.frame = CGRect(x: 0,
                                     y: lineOriginY + unitWidth,
                                     width: unitWidth,
                                     height: unitWidth)
        case 9:
            attribute.frame = CGRect(x: 0,
                                     y: lineOriginY,
                                     width: unitWidth,
                                     height: unitWidth)
        case 10:
            attribute.frame = CGRect(x: unitWidth,
                                     y: lineOriginY,
                                     width: unitWidth,
                                     height: unitWidth)
        case 11:
            attribute.frame = CGRect(x: unitWidth * 2,
                                     y: lineOriginY,
                                     width: unitWidth,
                                     height: unitWidth)
        default:
            break
        }

        // 每行3个图片，4行循环一次，一共12种位置

        return attribute
    }

    /*
     //如果有页眉、页脚或者背景，可以用下面的方法实现更多效果
     func layoutAttributesForSupplementaryViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     func layoutAttributesForDecorationViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     */
}
