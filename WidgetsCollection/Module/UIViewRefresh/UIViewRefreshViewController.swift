//
//  UIViewRefreshViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/23.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class UIViewRefreshViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    fileprivate func configureUI() {
        view.backgroundColor = .white

        view.addSubview(changeFrameBtn)
        view.addSubview(testView)

        changeFrameBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        testView.snp.makeConstraints { make in
            make.top.equalTo(changeFrameBtn.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
        }
    }

    @objc fileprivate func btnAction(_: UIButton) {
        // layoutIfNeeded会强制立即布局并显示更新，苹果建议在约束更改前调用一次以确保任何以前的更新等待、更新周期的完成
        view.layoutIfNeeded()
        if testView.frame.size.width == 50 {
            testView.snp.updateConstraints { make in
                make.size.equalTo(90)
            }
        } else {
            testView.snp.updateConstraints { make in
                make.size.equalTo(50)
            }
        }
        UIView.animate(withDuration: 2.0) {
            self.view.layoutIfNeeded()

            // 不会出现动画
//            self.view.setNeedsLayout()
        }
    }

    lazy var changeFrameBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("adjust Height", for: .normal)
        btn.setTitleColor(.randomColor(), for: .normal)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var testView: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()
}
