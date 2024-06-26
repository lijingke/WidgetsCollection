//
//  ChooseConfigureViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/22.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class ChooseConfigureViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .clear
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-200)
            make.right.equalToSuperview().offset(-50)
        }
    }

    lazy var mainView: ConfigureView = {
        let view = Bundle(for: ConfigureView.self).loadNibNamed("ConfigureView", owner: nil, options: nil)?.first as! ConfigureView
        view.backgroundColor = .cyan
        return view
    }()
}
