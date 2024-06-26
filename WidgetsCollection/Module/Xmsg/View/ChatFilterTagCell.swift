//
//  ChatFilterTagCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/1/2.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class ChatFilterTagCell: UITableViewCell {
    static let reuseId = "ChatFilterTagCell"

    var refreshAction: (() -> Void)?

    weak var delegate: ChatFilterEventProtocol?

    var tags: [tagViewModel]? {
        didSet {
            reloadData()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configureUI() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
        }
    }

    public func reloadData() {
        collectionView.reloadData()
        DispatchQueue.main.async {
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height + 10
            self.collectionView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            self.refreshAction?()
        }
    }

    lazy var collectionView: UICollectionView = {
        let layout = TagLayout()
        layout.headerHeight = 0
        layout.sectionHeaderHeight = 0
        layout.delegate = self
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ChatFilterTagCollectionCell.self, forCellWithReuseIdentifier: ChatFilterTagCollectionCell.reuseId)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        return view
    }()
}

extension ChatFilterTagCell: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return tags?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatFilterTagCollectionCell.reuseId, for: indexPath) as? ChatFilterTagCollectionCell else { return UICollectionViewCell() }
        cell.data = tags?[indexPath.item]
        return cell
    }
}

extension ChatFilterTagCell: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tags?[indexPath.item].isSelected = !(tags?[indexPath.item].isSelected ?? false)
        delegate?.tagChoosed(atInsexPath: indexPath, tag: tags?[indexPath.item] ?? tagViewModel())
    }
}

extension ChatFilterTagCell: TagLayoutDelegate {
    func collectionView(_: UICollectionView, TextForItemAt indexPath: IndexPath) -> String {
        return tags?[indexPath.item].title ?? ""
    }
}
