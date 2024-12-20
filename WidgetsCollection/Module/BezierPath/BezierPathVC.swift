//
//  BezierPathVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/20.
//

import Foundation

class BezierPathVC: BaseViewController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Lazy Get
    lazy var mainView: BezierPathView = {
        let view = BezierPathView()
        view.backgroundColor = .white
        return view
    }()
}

// MARK: - UI
extension BezierPathVC {
    private func setupUI() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
