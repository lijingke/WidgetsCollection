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
        // 修改导航栏标题文字颜色
        self.navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: UIColor.white]
        // 修改导航栏按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 设置视图的背景图片（自动拉伸）
        self.view.layer.contents = R.image.bg()!.cgImage
        setupUI()
    }
    
    // 视图将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置导航栏背景透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // 视图消失
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 重置导航栏背景
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MARK: Lazy Get

    lazy var mainView: LotteryView = {
        let view = LotteryView()
        return view
    }()
}

extension LotteryViewController {
    private func setupUI() {
        view.addSubview(self.mainView)
        self.mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
