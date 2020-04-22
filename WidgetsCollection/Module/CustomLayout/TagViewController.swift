//
//  TagViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/12.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class TagViewController: UIViewController {
    
    var tags: [[String]] = []
    
    var layout: TagLayout? {
        return collectionView.collectionViewLayout as? TagLayout
    }
    
    var headerKind: String {
        return layout?.headerKind ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        configureUI()
        configureData()
    }
    
    fileprivate func configureUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        navigationItem.rightBarButtonItems = [delBtn, addBtn]
    }
    
    fileprivate func configureData() {
        tags = DataManager.shared.generalTags()
        layout?.delegate = self
    }
    
    @objc private func addAction(_ sender: UIBarButtonItem) {
        let text = DataManager.shared.generalText()
        tags[0].append(text)
        let indexPath = IndexPath(item: tags[0].count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    @objc private func delAction(_ sender: UIBarButtonItem) {
        let count = tags[0].count
        if count == 0 {
            return
        }
        
        let indexPath = IndexPath(item: count - 1, section: 0)
        self.tags[0].remove(at: indexPath.row)
        collectionView.performBatchUpdates({ [weak self] in
            
            guard let `self` = self else {return}
            self.collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    lazy var delBtn: UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(delAction(_:)))
        return view
    }()
    
    lazy var addBtn: UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction(_:)))
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = TagLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseID)
         collection.register(BasicsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BasicsHeaderView.reuseID)
        collection.register(ImageHeaderViewOne.self, forSupplementaryViewOfKind: layout.headerKind, withReuseIdentifier: ImageHeaderViewOne.reuseID)
        DispatchQueue.main.async {
            
        }
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.alwaysBounceVertical = true
        return collection
    }()
}

// MARK: - UICollectionViewDataSource
extension TagViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return tags[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseID, for: indexPath) as! TagCell
      cell.value = tags[indexPath.section][indexPath.row]
      return cell
    }

}

// MARK: - UICollectionViewDelegate
extension TagViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      switch kind {
      case UICollectionView.elementKindSectionHeader:
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BasicsHeaderView.reuseID, for: indexPath) as! BasicsHeaderView
        view.titleLabel.text = "HEADER -- \(indexPath.section)"
        view.backgroundColor = UIColor.randomColor()
        return view
      case headerKind:
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImageHeaderViewOne.reuseID, for: indexPath) as! ImageHeaderViewOne
        return view
      default:
        fatalError("No such kind")
      }
    }

}

extension TagViewController: TagLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, TextForItemAt indexPath: IndexPath) -> String {
        return tags[indexPath.section][indexPath.row]
    }
}

 
class TagCell: UICollectionViewCell {
    
    static let reuseID = "tagCell"
    
    var value: String = "" {
        didSet {
            tagLabel.text = value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = .randomColor()
        tagLabel.font = UIFont.systemFont(ofSize: 12)
        tagLabel.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureUI() {
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}

class ImageHeaderViewOne: UICollectionReusableView {
    static let reuseID = "ImageHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "kt_sh")
        return view
    }()
    
}

class BasicsHeaderView: UICollectionReusableView {
    static let reuseID = "BasicsHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
}
