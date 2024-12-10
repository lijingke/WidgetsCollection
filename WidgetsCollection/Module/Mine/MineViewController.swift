//
//  MineViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit
import WCDBSwift
import MBProgressHUD

class MineViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        requeseUserInfo()
        testDB()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func getNavigatorConfig() -> NavigatorConfig? {
        return nil
    }
    
    lazy var mainView: MineView = {
        let view = MineView()
        view.backgroundColor = .white
        return view
    }()
}

// MARK: - UI

extension MineViewController {
    private func setupUI() {
        view.addSubview(mainView)
        mainView.frame = view.frame
    }

    private func setupData() {
        let titles: [[MineCellEnum: String]] = [[.cellName: "设置", .imageName: "gear"], [.cellName: "退出", .imageName: "wrench"]]
        let models = titles.compactMap { dic -> MineCellModel? in
            var model = MineCellModel()
            model.title = dic[.cellName]
            model.imageName = dic[.imageName]
            switch model.title {
            case "设置":
                model.tap = { [weak self] in
//                    Loading.showToastHint(with: "尚未完成", to: self.view)
                    let vc = SettingsViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case "退出":
                model.tap = {
//                    abort()
                    exit(1)
                    let window = UIApplication.shared.windows[0]

                    UIView.animate(withDuration: 10, animations: {
                        window.alpha = 1
                        window.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                    }) { _ in
                        exit(0)
                    }
                }
            default:
                break
            }
            return model
        }
        mainView.setupData(models)
    }

    private func requeseUserInfo() {
        MBProgressHUD.showAdded(to: mainView, animated: true)
        SMImageManager.shared.getUserInfo { model in
            self.mainView.setupUserInfo(model)
            MBProgressHUD.hide(for: self.mainView, animated: true)
        }
    }

    private func testDB() {
        DataBaseManager.share.createTable(table: "Some", of: DBSample.self)
    }
}

final class DBSample: TableCodable {
    var identifier: Int? = nil
    var description: String? = nil

    enum CodingKeys: String, CodingTableKey {
        typealias Root = DBSample
        static let objectRelationalMapping: TableBinding<DBSample.CodingKeys> = TableBinding(CodingKeys.self)
        case identifier
        case description
    }
}
