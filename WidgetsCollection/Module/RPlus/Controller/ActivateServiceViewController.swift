//
//  ActivateServiceViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/9.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation

class ActivateServiceViewController: UIViewController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Lazy Get
    lazy var mainView: ActivateServiceView = {
        let view = ActivateServiceView()
        return view
    }()
}

// MARK: - UI
extension ActivateServiceViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
