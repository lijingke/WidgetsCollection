//
//  CardLayoutViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/11.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class CardLayoutViewController: BaseViewController {
    var colors: [UIColor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureData()
    }

    fileprivate func configureUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    fileprivate func configureData() {
        colors = DataManager.shared.generalColor(20)
    }

    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: CardLayout())
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
        return collection
    }()
}

extension CardLayoutViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
}

extension CardLayoutViewController: UICollectionViewDelegate {}
