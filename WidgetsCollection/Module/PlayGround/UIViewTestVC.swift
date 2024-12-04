//
//  UIViewTestVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/2.
//

import Foundation
import UIKit

class UIViewTestVC: BaseViewController {
    // MARK: - Life Cycle

//    init() {
//        super.init(nibName: nil, bundle: nil)
//        Log.info("初始化")
//    }
//
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Log.info(" initWithCoder:(NSCoder *)aDecoder")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Log.info("init?(coder: NSCoder)")
    }
    
    override func loadView() {
        super.loadView()
        Log.info("loadView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Log.info("viewDidLoad")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Log.info("viewWillAppear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Log.info("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Log.info("viewDidLayoutSubviews")
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Log.info("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Log.info("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Log.info("viewDidDisappear")
    }
    
    deinit {
        Log.info("deinit")
    }

    // MARK: UI
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.textColor = .blue
//        label.numberOfLines = 0
        return label
    }()
    
    lazy var expandableLabel: ExpandableLabel = {
        let label = ExpandableLabel()
        label.numberOfLines = 3
        label.collapsed = true
        label.textColor = .black
        label.setLessLinkWith(lessLink: "Close", attributes: [.foregroundColor: UIColor.red], position: .right)
        label.shouldCollapse = true
        label.textReplacementType = .word
        label.delegate = self
        return label
    }()
}

// MARK: - ExpandableLabelDelegate

extension UIViewTestVC: ExpandableLabelDelegate {
    func willExpandLabel(_ label: ExpandableLabel) {
        Log.info("willExpandLabel")
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        Log.info("didExpandLabel")
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        Log.info("willCollapseLabel")
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        Log.info("didCollapseLabel")
    }
}

// MARK: - Data

extension UIViewTestVC {
    private func setupData() {
        let text = "Hello world"
        _ = text[100] // "d"
        _ = text[...20] // "Hello world"
        let sub = text[0 ..< 20] // "Hello world"
        Log.info(sub)
        label1.text = text[100]
        label2.text = text[1]
        expandableLabel.text = loremIpsumText()
    }
    
    func loremIpsumText() -> String {
        return "On third line our text need be collapsed because we have ordinary text, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
    }
}

// MARK: - UI

extension UIViewTestVC {
    private func setupUI() {
        view.addSubviews([label1, label2, expandableLabel])
        label1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(5)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(label1)
            make.left.equalTo(label1.snp.right)
            make.right.equalToSuperview().offset(-15)
        }
        expandableLabel.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
        }
        expandableLabel.setNeedsLayout()
    }
}
