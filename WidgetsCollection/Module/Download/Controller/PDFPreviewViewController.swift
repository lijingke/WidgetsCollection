//
//  PDFPreviewViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/6.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class PDFPreviewViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "卫生行业标准文件"
        configureUI()
    }

    fileprivate func configureUI() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    lazy var mainView: PDFPreviewView = {
        let view = PDFPreviewView()
        return view
    }()
}
