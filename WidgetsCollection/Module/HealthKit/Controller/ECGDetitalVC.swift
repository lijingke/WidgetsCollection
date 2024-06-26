//
//  ECGDetitalVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

class ECGDetitalVC: UIViewController {
    // MARK: Property

    var model: ECGModel?

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let ecgModel = model {
            mainView.refreshData(model: ecgModel)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        popGestureClose()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        popGestureOpen()
    }

    // MARK: Lazy Get

    lazy var mainView: ECGDetitalView = {
        let view = ECGDetitalView()
        return view
    }()
}

// MARK: - UI

extension ECGDetitalVC {
    private func setupUI() {
        title = "ECG Detail"
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Event

extension ECGDetitalVC {}
