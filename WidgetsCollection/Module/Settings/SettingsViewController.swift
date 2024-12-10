//
//  SettingsViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/10.
//

import Foundation
import UIKit

class SettingsViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func getNavigatorConfig() -> NavigatorConfig? {
        NavigatorConfig.newConfig().title(title: "Settings")
    }
    
    lazy var mainView: SettingsView = {
        let view = SettingsView()
        return view
    }()
}

// MARK: - UI

extension SettingsViewController {
    private func setupUI() {
        view.addSubview(mainView)
        mainView.frame = view.frame
    }
}
