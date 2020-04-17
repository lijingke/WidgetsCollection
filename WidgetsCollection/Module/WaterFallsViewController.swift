//
//  WaterFallsViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/12.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class WaterFallsViewController: UIViewController {
    
    var colors: [UIColor] = []
    
    var layout: WaterFallsLayout? {
        return collectionView.collectionViewLayout as? WaterFallsLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureData()
    }
    
    fileprivate func configureUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func configureData() {
        colors = DataManager.shared.generalColor(30)
        layout?.delegate = self
        layout?.minimumLineSpacing = 5
        layout?.minimumInteritemSpacing = 5
    }
    
    lazy var collectionView: UICollectionView = {
     
        let collection = UICollectionView(frame: .zero, collectionViewLayout: WaterFallsLayout())
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
        return collection
    }()

}

extension WaterFallsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    
}

extension WaterFallsViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension WaterFallsViewController: WaterFallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let random = arc4random_uniform(4) + 2
        return CGFloat(random * 50)
    }
}
