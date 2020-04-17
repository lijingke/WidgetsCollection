//
//  StretchyHeaderViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/12.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class StretchyHeaderViewController: UIViewController {
    
    var layout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? StretchyLayout
    }
    
    var colors: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureData()
    }
    
    fileprivate func configureUI() {
        
        let width = view.bounds.width
        layout?.itemSize = CGSize(width: width, height: 50)
        layout?.minimumLineSpacing = 2
        layout?.headerReferenceSize = CGSize(width: width, height: 150)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    fileprivate func configureData() {
        colors = DataManager.shared.generalColor(3)
    }
    
    lazy var collectionView: UICollectionView = {
     
        let collection = UICollectionView(frame: .zero, collectionViewLayout: StretchyLayout())
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
        collection.register(ImageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImageHeaderView.reuseID)
        collection.alwaysBounceVertical = true
        return collection
    }()
}

extension StretchyHeaderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    
}

extension StretchyHeaderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImageHeaderView.reuseID, for: indexPath)
            return view
        default:
            fatalError("No Such Kind")
        }
    }
}

class ImageHeaderView: UICollectionReusableView {
    
    static var reuseID = "imageHeadView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "kt_sh")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
}
