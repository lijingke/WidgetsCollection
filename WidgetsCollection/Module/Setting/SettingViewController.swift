//
//  SettingViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit
import MBProgressHUD

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        setupUI()
        setupData()
        requeseUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    lazy var mainView: SettingView = {
        let view = SettingView()
        view.backgroundColor = .white
        return view
    }()
}

// MARK: - UI
extension SettingViewController {
    private func setupUI() {
        view.addSubview(mainView)
        mainView.frame = view.frame
    }
    
    private func setupData() {
        let titles:[[SettingCellEnum : String]] = [[.cellName: "Setting", .imageName: "gear"]]
        let models = titles.compactMap { (dic) -> SettingCellModel? in
            var model = SettingCellModel()
            model.title = dic[.cellName]
            model.imageName = dic[.imageName]
            model.tap = {
                Loading.showToastHint(with: "sfsf", to: self.view)
            }
            return model
        }
        mainView.setupData(models)
    }
    
    private func requeseUserInfo() {
//        MBProgressHUD.showAdded(to: self.mainView, animated: true)
//        SMImageManager.shared.getUserInfo { (model) in
//            self.mainView.setupUserInfo(model)
//            MBProgressHUD.hide(for: self.mainView, animated: true)
//        }
    }
}
