//
//  UIViewTestVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/2.
//

import Foundation
import UIKit

class UIViewTestVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    // MARK: UI
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.textColor = .blue
//        label.numberOfLines = 0
        return label
    }()
}

// MARK: - Data
extension UIViewTestVC {
    private func setupData() {
        let text = "Hello world"
        text[100] // "d"
        text[...20] // "Hello world"
        let sub = text[0..<20] // "Hello world"
        Log.info(String(sub))
    }
}

// MARK: - UI
extension UIViewTestVC {
    private func setupUI() {
        view.addSubviews([label1, label2])
        label1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(label1)
            make.left.equalTo(label1.snp.right)
            make.right.equalToSuperview().offset(-15)
        }
    }
}