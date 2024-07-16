//
//  LotteryViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/12/31.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import UIKit

class LotteryViewController: BaseViewController {
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .all
        // 设置视图的背景图片（自动拉伸）
        view.layer.contents = R.image.bg()!.cgImage
        setupUI()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        appearance.shadowImage = UIImage(color: .clear)
        appearance.backgroundEffect = nil
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    // 视图将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 修改导航栏按钮颜色
        navigationController?.navigationBar.tintColor = UIColor.green
    }

    // 视图消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowImage = UIImage(color: .white)
        appearance.backgroundEffect = nil
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        // 修改导航栏按钮颜色
        navigationController?.navigationBar.tintColor = UIColor.black
    }

    // MARK: Lazy Get

    lazy var mainView: LotteryView = {
        let view = LotteryView()
        return view
    }()
}

extension LotteryViewController {
    private func setupUI() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
