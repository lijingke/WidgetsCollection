//
//  LayoutAndDelegateViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/11.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class LayoutAndDelegateViewController: UIViewController {
    
    var colors: [[UIColor]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurationData()
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        collectionView.addGestureRecognizer(longGesture)
    }
    
    fileprivate func configurationData() {
        colors.append(DataManager.shared.generalColor(3))
        colors.append(DataManager.shared.generalColor(4))
        colors.append(DataManager.shared.generalColor(5))
    }
    
    @objc func longPressed(_ gesture: UILongPressGestureRecognizer) {
        let position = gesture.location(in: collectionView)
        switch gesture.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: position) {
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(position)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collection.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
        collection.register(collectionHead.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionHead.reuseID)
        collection.register(CollectionFoot.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionFoot.reuseID)
        return collection
    }()
    
    fileprivate func configureUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension LayoutAndDelegateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let itemWidth = (view.bounds.width - 20) / 3
            return CGSize(width: itemWidth, height: itemWidth)
        }else if indexPath.section == 1 {
            return CGSize(width: view.bounds.width, height: 50)
        }else {
            let itemWidth = (view.bounds.width - 15)/2
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        }else if section == 1 {
            return UIEdgeInsets(top: 30, left: 20, bottom: 60, right: 30)
        }else {
            return UIEdgeInsets(top: 3, left: 0, bottom: 6, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 2
        }else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 2
        }else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = view.bounds.width
        if section == 0 {
            return CGSize(width: width, height: 30)
        }else if section == 1 {
            return CGSize(width: width, height: 50)
        }else {
            return CGSize(width: width, height: 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = view.bounds.width
        return CGSize(width: width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: 0.1) {
            cell.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard  let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: 0.1) {
            cell.transform = CGAffineTransform.identity
        }
    }
}

extension LayoutAndDelegateViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionHead.reuseID, for: indexPath) as! collectionHead
            view.titleLabel.text = "Head \(indexPath.section)"
            return view
            
        case UICollectionView.elementKindSectionFooter:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionFoot.reuseID, for: indexPath) as! CollectionFoot
            view.titleLabel.text = "Foot \(indexPath.section)"
            return view
            
        default:
            fatalError("No Such Kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 修改数据源
        let removeColor = self.colors[sourceIndexPath.section][sourceIndexPath.row]
        self.colors[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        self.colors[destinationIndexPath.section].insert(removeColor, at: destinationIndexPath.row)
    }
    
    
}

class collectionHeadTwo: UICollectionReusableView {
    static let reuseID = "headView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurationUI()
    }
    
    fileprivate func configurationUI() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}

class CollectionFootTwo: UICollectionReusableView {
    static let reuseID = "footView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurationUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configurationUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}

