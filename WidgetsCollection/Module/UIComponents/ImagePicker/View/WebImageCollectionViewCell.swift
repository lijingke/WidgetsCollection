//
//  WebImageCollectionViewCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/22.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class WebImageCollectionViewCell: UICollectionViewCell {
    static let reuseId = "WebImageCollectionViewCell"

    public var tapBlock: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))

        imageView.addGestureRecognizer(tap)
    }

    @objc private func tapAction() {
        tapBlock?()
    }

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        return view
    }()
}
