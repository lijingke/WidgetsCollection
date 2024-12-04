//
//  TagLayout.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/12.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

enum Element {
    case cell
    case header
    case sectionHeader
}

protocol TagLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, TextForItemAt indexPath: IndexPath) -> String
}

class TagLayout: UICollectionViewLayout {
    // 标签的内边距
    var tagInnerMargin: CGFloat = 25
    // 元素间距
    var itemSpacing: CGFloat = 10
    // 行间距
    var lineSpacing: CGFloat = 10
    // 标签的高度
    var itemHeight: CGFloat = 25
    // 标签的字体
    var itemFont: UIFont = .systemFont(ofSize: 12)
    // header的高度
    var headerHeight: CGFloat = 150
    // sectionHeader 高度
    var sectionHeaderHeight: CGFloat = 50
    // header的类型
    let headerKind = "ElementTagHeader"

    weak var delegate: TagLayoutDelegate?

    // 缓存
    private var cache = [Element: [IndexPath: UICollectionViewLayoutAttributes]]()
    // 可见区域
    private var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    // 内容高度
    private var contentHeight: CGFloat = 0
    // 用来记录新增的元素
    private var insertIndexPaths = [IndexPath]()
    // 用来记录删除的元素
    private var deleteIndexPaths = [IndexPath]()

    // MARK: - 一些计算属性 防止编写冗余代码

    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width
    }

    override func prepare() {
        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }
        let sections = collectionView.numberOfSections

        prepareCache()
        contentHeight = 0

        /// 可伸缩header
        let headerIndexPath = IndexPath(item: 0, section: 0)
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: headerKind, with: headerIndexPath)
        let frame = CGRect(x: 0, y: 0, width: collectionViewWidth, height: headerHeight)
        headerAttribute.frame = frame
        cache[.header]?[headerIndexPath] = headerAttribute
        contentHeight = frame.maxY

        for section in 0 ..< sections {
            let sectionHeaderIndexPath = IndexPath(item: 0, section: section)

            let sectionHeaderAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: sectionHeaderIndexPath)
            var sectionOriginY = contentHeight
            if section != 0 {
                sectionOriginY += lineSpacing
            }
            let sectionFrame = CGRect(x: 0, y: sectionOriginY, width: collectionViewWidth, height: sectionHeaderHeight)
            sectionHeaderAttribute.frame = sectionFrame
            cache[.sectionHeader]?[sectionHeaderIndexPath] = sectionHeaderAttribute
            contentHeight = sectionFrame.maxY

            // 处理tag
            let rows = collectionView.numberOfItems(inSection: section)
            var frame = CGRect(x: 0, y: contentHeight + lineSpacing, width: 0, height: 0)

            for item in 0 ..< rows {
                let indexPath = IndexPath(item: item, section: section)

                let text = delegate.collectionView(collectionView, TextForItemAt: indexPath)
                let tagWidth = textWidth(text) + tagInnerMargin

                // 其他
                if frame.maxX + tagWidth + itemSpacing * 2 > collectionViewWidth {
                    // 需要换行
                    frame = CGRect(x: itemSpacing, y: frame.maxY + lineSpacing, width: tagWidth, height: itemHeight)
                } else {
                    frame = CGRect(x: frame.maxX + itemSpacing, y: frame.origin.y, width: tagWidth, height: itemHeight)
                }

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache[.cell]?[indexPath] = attributes
            }
            contentHeight = frame.maxY
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: contentHeight)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[.cell]?[indexPath]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        visibleLayoutAttributes.removeAll(keepingCapacity: true)
        for (type, elementInfos) in cache {
            for (_, attributes) in elementInfos where attributes.frame.intersects(rect) {
                if let deltalY = self.calculateDeltalY(), type == .header {
                    var headerRect = attributes.frame
                    headerRect.size.height = headerRect.height + deltalY
                    headerRect.origin.y = headerRect.origin.y - deltalY
                    attributes.frame = headerRect
                }
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return cache[.sectionHeader]?[indexPath]
        case headerKind:
            return cache[.header]?[indexPath]
        default:
            return nil
        }
    }

    private func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.sectionHeader] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache[.cell] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache[.header] = [IndexPath: UICollectionViewLayoutAttributes]()
    }

    override public func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        return true
    }

    private func calculateDeltalY() -> CGFloat? {
        guard let collectionView = collectionView else {
            return nil
        }
        let insets = collectionView.contentInset
        let offset = collectionView.contentOffset
        let minY = -insets.top

        if offset.y < minY {
            let deltalY = abs(offset.y - minY)
            return deltalY
        }
        return nil
    }

    private func textWidth(_ text: String) -> CGFloat {
        let rect = (text as NSString).boundingRect(with: .zero, options: .usesLineFragmentOrigin, attributes: [.font: itemFont], context: nil)
        return rect.width
    }

    // MARK: 动画相关

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attribute = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else {
            return nil
        }
        if insertIndexPaths.contains(itemIndexPath) {
            attribute.transform = CGAffineTransform.identity.scaledBy(x: 4, y: 4).rotated(by: CGFloat(Double.pi / 2))
        }
        return attribute
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else {
            return nil
        }
        if deleteIndexPaths.contains(itemIndexPath) {
            attribute.transform = CGAffineTransform.identity.scaledBy(x: 4, y: 4).rotated(by: CGFloat(Double.pi / 2))
        }

        return attribute
    }

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        insertIndexPaths.removeAll()
        deleteIndexPaths.removeAll()
        for update in updateItems {
            switch update.updateAction {
            case .insert:
                if let indexPath = update.indexPathAfterUpdate {
                    insertIndexPaths.append(indexPath)
                }
            case .delete:
                if let indexPath = update.indexPathBeforeUpdate {
                    deleteIndexPaths.append(indexPath)
                }
            default:
                break
            }
        }
    }
}
