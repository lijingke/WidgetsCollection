//
//  SettingsViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/10.
//

import Foundation
import UIKit

class SettingsViewController: BaseViewController {
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addListener()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.refreshSettings()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func getNavigatorConfig() -> NavigatorConfig? {
        NavigatorConfig.newConfig().title(title: "Settings")
    }

    // MARK: Lazy Get

    lazy var mainView: SettingsView = {
        let view = SettingsView()
        return view
    }()
}

// MARK: - Event

extension SettingsViewController {
    private func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func appDidBecomeActive() {
        // 当应用程序变为活跃状态时，这里执行你的刷新操作
        Log.info("应用程序变为活跃状态，可以进行数据刷新")
        // 例如，刷新UI
        // self.refreshUI()
        mainView.refreshSettings()
    }
}

// MARK: - UI

extension SettingsViewController {
    private func setupUI() {
        view.addSubview(mainView)
        mainView.frame = view.frame
    }
}
