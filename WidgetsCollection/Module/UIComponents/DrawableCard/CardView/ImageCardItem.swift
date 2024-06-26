//
//  ImageCardItem.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/8.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class ImageCardItem: CardItem {
    var image: UIImage
    var imageView: UIImageView!

    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        initView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    private func initView() {
        imageView = UIImageView()
        imageView.image = image
        contentView.addSubview(imageView)
    }
}
