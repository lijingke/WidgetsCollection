//
//  AppSearchViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/29.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

protocol SomeProtocol {
    func someFunc()
}

class AppSearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }        
    }
    
    deinit {
        debugPrint("bye bye!")
    }
    
    lazy var mainView: SearchView = {
        let view = SearchView()
        view.delegate = self
        return view
    }()
    
}

extension AppSearchViewController: SomeProtocol {
    func someFunc() {
        print("biubiu")
    }
}

class SearchView: UIView {
    
    var delegate: SomeProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .link
        addSubview(testBtn)
        testBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var testBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Test Delegate", for: .normal)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func btnAction(_ sender: UIButton) {
        delegate?.someFunc()
    }
}
