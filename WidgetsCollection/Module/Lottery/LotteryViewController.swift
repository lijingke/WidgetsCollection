//
//  LotteryViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/12/31.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import UIKit

class LotteryViewController: UIViewController {
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置视图的背景图片（自动拉伸）
        view.layer.contents = R.image.bg()!.cgImage
        setupUI()
    }

    // 视图将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 修改导航栏标题文字颜色
        navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: UIColor.white]
        // 修改导航栏按钮颜色
        navigationController?.navigationBar.tintColor = UIColor.white
        // 设置导航栏背景透明
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    // 视图消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 恢复导航栏标题文字颜色
        navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: UIColor.black]
        // 恢复导航栏按钮颜色
        navigationController?.navigationBar.tintColor = UIColor.black
        // 重置导航栏背景
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
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
