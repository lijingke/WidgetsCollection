//
//  StretchyLayout.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/12.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class StretchyLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else {
            return nil
        }
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let insets = collectionView.contentInset
        let offset = collectionView.contentOffset
        let minY = -insets.top
        
        if offset.y < minY {
            let headerSize = self.headerReferenceSize
            let deltalY = abs(offset.y - minY)
            for attribute in attributes {
                if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                    var headerRect = attribute.frame
                    headerRect.size.height = headerSize.height + deltalY
                    headerRect.origin.y = headerRect.origin.y - deltalY
                    attribute.frame = headerRect
                }
            }
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
