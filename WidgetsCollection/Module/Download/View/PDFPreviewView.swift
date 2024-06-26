//
//  PDFPreviewView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/6.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit
import WebKit

class PDFPreviewView: UIView {
    public var filePath: String? {
        didSet {
            configureData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
//        configureData()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configureUI() {
        backgroundColor = .systemGroupedBackground
        addSubview(headInfoView)
        addSubview(pdfWebView)
        headInfoView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(110)
        }
        pdfWebView.snp.makeConstraints { make in
            make.top.equalTo(headInfoView.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
    }

    fileprivate func configureData() {
        if let pdf = Bundle.main.path(forAuxiliaryExecutable: filePath ?? "") {
            let url = URL(fileURLWithPath: pdf)
            let request = URLRequest(url: url)
            pdfWebView.load(request)
        }
    }

    lazy var pdfWebView: WKWebView = {
        let view = WKWebView()
        return view
    }()

    lazy var headInfoView: PDFInfoHeadView = {
        let view = PDFInfoHeadView()
        return view
    }()
}
