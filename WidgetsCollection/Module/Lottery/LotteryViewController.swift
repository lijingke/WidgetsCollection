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
    }

    // 视图将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // 视图消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func getNavigatorConfig() -> NavigatorConfig? {
        return NavigatorConfig.newConfig().tinColor(color: .green).isTranslucent(true)
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
