//
//  CardLayout.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/11.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class CardLayout: UICollectionViewFlowLayout {
    
    /// MARK: - 一些计算属性，防止编写冗余代码
    private var collectionViewHeight: CGFloat {
        return collectionView!.frame.height
    }
    
    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width
    }
    
    private var cellWidth: CGFloat {
        return collectionViewWidth * 0.7
    }
    
    private var cellMargin: CGFloat {
        return (collectionViewWidth - cellWidth) / 7
    }
    
    /// 内边距
    private var margin: CGFloat {
        return (collectionViewWidth - cellWidth) / 2
    }
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        minimumLineSpacing = cellMargin
        itemSize = CGSize(width: cellWidth, height: collectionViewHeight * 0.75)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else {
            return nil
        }
        
        guard let visibleAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let centerX = collectionView.contentOffset.x + collectionView.bounds.size.width / 2

        for attribute in visibleAttributes {
            let distance = abs(attribute.center.x - centerX)
            let aprtScale = distance / collectionView.bounds.size.width
            let scale = abs(cos(aprtScale * CGFloat(Double.pi / 4)))
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return visibleAttributes
        
    }
    
    // 是否实时刷新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
