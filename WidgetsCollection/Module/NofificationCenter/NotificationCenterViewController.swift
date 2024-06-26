//
//  NotificationCenterViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/11/18.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class NotificationCenterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addListener()
        configureUI()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("通知---注销")
    }

    fileprivate func configureUI() {
        view.backgroundColor = .white
        view.addSubview(triggerBtn)
        view.addSubview(textFiled)
        triggerBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        textFiled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(triggerBtn.snp.top).offset(-20)
        }
        textFiled.textAlignment = .center
    }

    fileprivate func addListener() {
        daddy.careAboutBaby()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationEvent(sender:)), name: UITextField.textDidChangeNotification, object: textFiled)
    }

    @objc fileprivate func notificationEvent(sender: AnyObject) {
        view.backgroundColor = .darkGray
        print("通知---调用")
        if sender is UIButton {
            baby.hunger😫()
        }
        if sender is Notification {
            let object = sender.object as? UITextField
            if let text = object?.text {
                print(text)
            }
        }
    }

    lazy var daddy = Daddy()
    lazy var baby = Baby()

    lazy var triggerBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Hungry", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.systemBlue
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(notificationEvent), for: .touchDown)
        return btn
    }()

    lazy var textFiled: UITextField = {
        let field = UITextField()
        field.placeholder = "请输入一些内容"
        field.textAlignment = NSTextAlignment.center
        return field
    }()
}

class Daddy {
    func careAboutBaby() {
        NotificationCenter.default.addObserver(self, selector: #selector(daddyIsComing🤗), name: NSNotification.Name(rawValue: Baby.CRY), object: nil)
    }

    @objc func daddyIsComing🤗() {
        print("daddy is coming")
    }
}

class Baby {
    static let CRY = "BABY_CRY"
    func hunger😫() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Baby.CRY), object: nil)
    }
}
