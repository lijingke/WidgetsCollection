//
//  TisprCardStackViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/9.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class TisprCardStackViewController: CardStackViewController {
    private enum Constans {
        static let cellIdentifier = "TisprCardStackDemoViewCellIdentifier"
        static let animationSpeed: Float = 0.86
        static let padding: CGFloat = 20.0
        static let kHeight: CGFloat = 0.67
        static let topStackVisibleCardCount = 40
        static let bottomStackVisibleCardCount = 30
        static let bottomStackCardHeight: CGFloat = 45.0
        static let colors = [UIColor(red: 45.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0),
                             UIColor(red: 48.0 / 255.0, green: 173.0 / 255.0, blue: 99.0 / 255.0, alpha: 1.0),
                             UIColor(red: 141.0 / 255.0, green: 72.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0),
                             UIColor(red: 241.0 / 255.0, green: 155.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0),
                             UIColor(red: 234.0 / 255.0, green: 78.0 / 255.0, blue: 131.0 / 255.0, alpha: 1.0),
                             UIColor(red: 80.0 / 255.0, green: 170.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)]
    }

    fileprivate var countOfCards: Int = 6

    convenience init() {
        let layout = CardStackViewLayout()
        // configuration of stacks
        layout.topStackMaximumSize = Constans.topStackVisibleCardCount
        layout.bottomStackMaximumSize = Constans.bottomStackVisibleCardCount
        layout.bottomStackCardHeight = Constans.bottomStackCardHeight
        self.init(collectionViewLayout: layout)
    }

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()

        collectionView.register(TisprCardStackDemoViewCell.self, forCellWithReuseIdentifier: Constans.cellIdentifier)
        collectionView.backgroundColor = .purple
        delegate = self
        datasource = self

        // set size of cards
        let size = CGSize(width: view.bounds.width - 2 * Constans.padding, height: Constans.kHeight * view.bounds.height)
        setCardSize(size)
    }
}

// MARK: - UI

extension TisprCardStackViewController {
    private func setupNavBar() {
        let backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(backAction))
        let trashBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashAction))

        let addBtn = UIBarButtonItem(image: UIImage(named: "icon_plus"), style: .plain, target: self, action: #selector(addAction))
        let upBtn = UIBarButtonItem(image: UIImage(named: "arrow_up"), style: .plain, target: self, action: #selector(upAction))
        let downBtn = UIBarButtonItem(image: UIImage(named: "arrow_down"), style: .plain, target: self, action: #selector(downAction))
        navigationItem.leftBarButtonItems = [backBtn, trashBtn]
        navigationItem.rightBarButtonItems = [addBtn, upBtn, downBtn]

        navigationItem.title = ""
    }
}

// MARK: - CardStackDelegate

extension TisprCardStackViewController: CardStackDelegate {
    func cardDidChangeState(_: Int) {
        // Method to obverse card postion changes
    }
}

// MARK: - CardStackDatasource

extension TisprCardStackViewController: CardStackDatasource {
    func numberOfCards(in _: CardStackView) -> Int {
        return countOfCards
    }

    func card(_ cardStack: CardStackView, cardForItemAtIndex index: IndexPath) -> CardStackViewCell {
        let cell = cardStack.dequeueReusableCell(withReuseIdentifier: Constans.cellIdentifier, for: index) as! TisprCardStackDemoViewCell
        cell.backgroundColor = Constans.colors[index.item % Constans.colors.count]
        cell.text.text = "№ \(index.item)"
        return cell
    }
}

// MARK: - BarButtonClickEvent

extension TisprCardStackViewController {
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func trashAction() {
        print("delete item")
        countOfCards -= 1
        deleteCard()
    }

    @objc private func addAction() {
        print("add item")
        countOfCards += 1
        newCardAdded()
    }

    @objc private func upAction() {
        print("up")
        moveCardUp()
    }

    @objc private func downAction() {
        print("down")
        moveCardDown()
    }
}
