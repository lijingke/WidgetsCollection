//
//  CardView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/8.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

/**************     最上面那张的序号是 0      *****************/

enum CardDirection {
    case up, left, down, right
}

protocol CardViewDelegate: AnyObject {
    func didClick(cardView: CardView, with index: Int)
    func remove(cardView: CardView, item: CardItem, with index: Int)
    func revoke(cardView: CardView, item: CardItem, with index: Int)
}

protocol CardViewDataSource: AnyObject {
    func numberOfItems(in cardView: CardView) -> Int
    func cardView(_ cardView: CardView, cellForItemAt index: Int) -> CardItem
    func cardView(_ cardView: CardView, sizeForItemAt index: Int) -> CGSize
}

extension CardViewDataSource {
    func cardView(_ cardView: CardView, sizeForItemAt _: Int) -> CGSize {
        return cardView.frame.size
    }
}

private let tagMark = 100

class CardView: UIView {
    weak var delegate: CardViewDelegate?
    weak var dataSource: CardViewDataSource?

    /// 是否完全重叠， 默认否
    var isOverlap = false
    var isEmpty: Bool {
        return count == 0
    }

    private var count: Int = 0
    private var lastFrames = [Int: CGRect]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadData() {
        guard let dataSource = dataSource else { return }
        count = dataSource.numberOfItems(in: self)
        for index in 0 ..< count {
            addCard(with: index)
        }
    }

    private func addCard(with index: Int) {
        let item = creatItem(with: index)
        insertSubview(item, at: 0)
        if !isOverlap {
            let scale = 1 - 0.05 * CGFloat(index)
            UIView.animate(withDuration: 0.1) {
                let transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: 0, y: 25 * CGFloat(index))
                item.transform = transform
            }
        }

        item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))

        if index == 0 {
            item.isUserInteractionEnabled = true
        }
    }

    private func creatItem(with index: Int) -> CardItem {
        let size = itemSize(at: index)
        let item = itemView(at: index)
        item.delegate = self
        item.tag = index + tagMark
        item.frame = CGRect(x: frame.width * 0.5 - size.width * 0.5, y: frame.height * 0.5 - size.height * 0.5, width: size.width, height: size.height)
        return item
    }

    @objc private func handleTapGesture(_ tap: UITapGestureRecognizer) {
        guard let tapView = tap.view else { return }
        delegate?.didClick(cardView: self, with: tapView.tag - tagMark)
    }

    private func itemSize(at index: Int) -> CGSize {
        guard let dataSource = dataSource, index < count else {
            return frame.size
        }

        var size = dataSource.cardView(self, sizeForItemAt: index)
        if size.width > frame.width || size.width == 0 {
            print("warning: item.width == 0")
            size.width = frame.width
        }
        if size.height > frame.height || size.height == 0 {
            print("warning: item.height == 0")
            size.height = frame.height
        }
        return size
    }

    private func itemView(at index: Int) -> CardItem {
        guard let dataSource = dataSource else {
            return CardItem()
        }
        return dataSource.cardView(self, cellForItemAt: index)
    }

    public func removeAll(animated: Bool = true) {
        for (index, item) in subviews.reversed().enumerated() {
            if let item = item as? CardItem {
                if animated {
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.1 * Double(index))) {
                        item.remove(animated: true)
                    }
                } else {
                    item.remove(animated: false)
                }
            }
        }
    }

    public func removeTopItem(with direction: CardDirection = .right, angle: CGFloat = 0) {
        if let item = subviews.last as? CardItem {
            item.remove(with: direction, angle: angle)
        }
    }

    /// 返回上一张卡片.
    public func revokeCard() {
        if let topItem = subviews.last as? CardItem {
            let index = topItem.tag - tagMark - 1
            guard index >= 0, let lastFrame = lastFrames[index] else {
                print("no item to revoke")
                return
            }
            let item = creatItem(with: index)
            addSubview(item)
            item.isHidden = true
            UIView.animate(withDuration: 0.01, animations: {
                item.transform = CGAffineTransform(translationX: lastFrame.origin.x, y: lastFrame.origin.y)
            }) { _ in
                item.isHidden = false
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    item.transform = CGAffineTransform.identity
                    self?.relayoutItem(isRevoke: true)
                }) { [weak self] _ in
                    guard let `self` = self else { return }
                    self.delegate?.revoke(cardView: self, item: item, with: index)
                }
            }
        }
    }

    private func relayoutItem(isRevoke: Bool = false) {
        for (index, item) in subviews.reversed().enumerated() {
            if index == 0 {
                item.isUserInteractionEnabled = true
                if isRevoke { continue }
            }
            if !isOverlap {
                UIView.animate(withDuration: 0.1) {
                    let scale = 1 - 0.05 * CGFloat(index)
                    UIView.animate(withDuration: 0.1) {
                        let transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: 0, y: 25 * CGFloat(index))
                        item.transform = transform
                    }
                }
            }
        }
    }
}

// MARK: - CardItemDelegate

extension CardView: CardItemDelegate {
    func removeFromSuperView(item: CardItem) {
        let index = item.tag - tagMark
        lastFrames[index] = item.frame
        if count > 0 {
            count -= 1
        }
        relayoutItem()
        delegate?.remove(cardView: self, item: item, with: index)
    }
}
