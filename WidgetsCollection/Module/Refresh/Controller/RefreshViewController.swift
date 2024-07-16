//
//  RefreshViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/8/3.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

class RefreshViewController: BaseViewController {
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Lazy Get

    lazy var mainView: RefreshView = {
        let view = RefreshView()
        return view
    }()
}

// MARK: - UI

extension RefreshViewController {
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .green
        navigationController?.navigationBar.barTintColor = .green
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
