//
//  TapLabelVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/4.
//

import Foundation
import ZhuoZhuo

class TapLabelVC: BaseViewController {
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }

    // MARK: Lazy Get

    lazy var mainView: InfoListView = {
        let view = InfoListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// MARK: - Data

extension TapLabelVC {
    private func requestData() {
        Loading.showLoading(to: view)
        DispatchQueue.global().async { [weak self] in
            guard let weakSelf = self else { return }
            let data = RdTestGetResource__NotAllowedInMainThread() ?? []
            DispatchQueue.main.async {
                weakSelf.mainView.setupData(data)
                Loading.hideLoading(from: weakSelf.view)
            }
        }
    }
}

// MARK: - UI

extension TapLabelVC {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
