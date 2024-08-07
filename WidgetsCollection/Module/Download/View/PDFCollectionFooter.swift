//
//  PDFCollectionFooter.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class PDFCollectionFooter: UICollectionReusableView {
    static let reuseID = "PDFCollectionFooter"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
