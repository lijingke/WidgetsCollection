//
//  WaterFallsLayout.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/12.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

protocol WaterFallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class WaterFallsLayout: UICollectionViewLayout {
    var numberOfColumns = 2
    var minimumLineSpacing: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0

    // 代理 用来获取元素的高度
    var delegate: WaterFallLayoutDelegate?

    // 缓存，将计算好的 UICollectionViewLayoutAttributes 存储起来，防止重复计算
    private var cache = [UICollectionViewLayoutAttributes]()

    // 内容高度，为collectionViewContentSize 准备
    private var contentHeight: CGFloat = 0

    private var width: CGFloat {
        return collectionView!.bounds.width
    }

    override func prepare() {
        if let collectionView = collectionView, let delegate = delegate, cache.isEmpty {
            let columnWidth = (width - (CGFloat(numberOfColumns) + 1) * minimumInteritemSpacing) / CGFloat(numberOfColumns)

            var xOffsets = [CGFloat]()
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * columnWidth + minimumInteritemSpacing * CGFloat(column + 1))
            }

            var yOffsets = [CGFloat](repeating: minimumInteritemSpacing, count: numberOfColumns)
            var column = 0
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let height = delegate.collectionView(collectionView, heightForItemAt: indexPath)
                let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)

                print("Each Frame \(frame)")

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[column] = yOffsets[column] + height + minimumInteritemSpacing
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                layoutAttributes.append(attribute)
            }
        }
        return layoutAttributes
    }
}
