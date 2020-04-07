//
//  PDFDownloadView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit
import Tiercel

protocol PDFDownloadDelegate: NSObject {
    func downloadCellDidClicked(_ cell: PDFCollectionCell)
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class PDFDownloadView: UIView {
    
    weak var delegate: PDFDownloadDelegate?
    
    var dataSource: [[PDFEntity]] = [[PDFEntity]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("View Leave")
    }
    
    fileprivate func configureUI() {
        self.backgroundColor = .white
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public func setupData(_ data: [[PDFEntity]]) {
        dataSource = data
        collectionView.reloadData()
    }
    
    lazy var collectionView: UICollectionView = {
        let itemWidth = (UIScreen.main.bounds.width - 30 * 4) / 3
        let itemHeight = itemWidth * 1.5728
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight + 70)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        layout.footerReferenceSize = CGSize(width: self.bounds.width, height: 5)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor(hex: 0xF5F8FA)
        collection.dataSource = self
        collection.delegate = self
        collection.register(PDFCollectionCell.self, forCellWithReuseIdentifier: PDFCollectionCell.reuseId)
        collection.register(PDFCollectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PDFCollectionFooter.reuseID)
        return collection
    }()
}

extension PDFDownloadView: UICollectionViewDelegate {
    
}

extension PDFDownloadView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PDFCollectionCell.reuseId, for: indexPath) as? PDFCollectionCell else {
            return UICollectionViewCell()
        }
        cell.entity = dataSource[indexPath.section][indexPath.row]
        cell.tapBlock = { [weak self] in
            self?.delegate?.downloadCellDidClicked(cell)
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PDFCollectionFooter.reuseID, for: indexPath) as! PDFCollectionFooter
            return view
        default:
            fatalError("No Such Kind")
        }
    }
    
}
