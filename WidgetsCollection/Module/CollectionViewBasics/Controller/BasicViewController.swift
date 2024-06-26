//
//  BasicViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/11.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    var colors: [[UIColor]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        colors.append(DataManager.shared.generalColor(20))
        colors.append(DataManager.shared.generalColor(8))
        colors.append(DataManager.shared.generalColor(7))
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 20) / 3, height: (UIScreen.main.bounds.width - 20) / 3)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 50)
        layout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: 30)
        layout.sectionHeadersPinToVisibleBounds = true
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
        collection.register(CollectionLabelHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionLabelHeadView.reuseID)
        collection.register(CollectionLabelFootView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionLabelFootView.reuseID)
        return collection
    }()

    fileprivate func configureUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension BasicViewController: UICollectionViewDelegate {}

extension BasicViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return colors.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        cell.backgroundColor = colors[indexPath.section][indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionLabelHeadView.reuseID, for: indexPath) as! CollectionLabelHeadView
            view.titleLabel.text = "Head \(indexPath.section)"
            return view

        case UICollectionView.elementKindSectionFooter:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionLabelFootView.reuseID, for: indexPath) as! CollectionLabelFootView
            view.titleLabel.text = "Foot \(indexPath.section)"
            return view

        default:
            fatalError("No Such Kind")
        }
    }
}
