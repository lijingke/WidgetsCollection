//
//  UIPasteboardViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/14.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class UIPasteboardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setupUI()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(pasteBtn)
        view.addSubview(textView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pasteBtn.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .top, multiplier: 2, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -30))

        view.addConstraint(NSLayoutConstraint(item: pasteBtn, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pasteBtn, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 30))

        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 300))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200))

        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: pasteBtn, attribute: .bottom, multiplier: 1, constant: 30))

        view.addSubview(defaultImgView)
        view.addSubview(copyImgView)

        let width = (kScreenWidth - 30 * 3) / 2
        let height = width * 1.5
        defaultImgView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(30)
            make.size.equalTo(CGSize(width: width, height: height))
        }

        copyImgView.snp.makeConstraints { make in
            make.top.size.equalTo(defaultImgView)
            make.right.equalToSuperview().offset(-30)
        }
    }

    @objc private func btnAction() {
        UIPasteboard.general.string = titleLabel.text

        let alertVC = UIAlertController(title: nil, message: "复制成功！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default) { [weak self] _ in
            self?.textView.becomeFirstResponder()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }

    lazy var titleLabel: UICopyLabel = {
        let label = UICopyLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "点击下方的复制按钮或是长按这段话，会将这段话复制到剪贴板中"
        return label
    }()

    lazy var pasteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("复制", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return btn
    }()

    lazy var textView: UITextView = {
        let view = UITextView()
        view.delegate = self
        return view
    }()

    lazy var defaultImgView: UICopyImageView = {
        let view = UICopyImageView(frame: .zero)
        view.image = #imageLiteral(resourceName: "Van Gogh_Starry Night")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    lazy var copyImgView: UICopyImageView = {
        let view = UICopyImageView(frame: .zero)
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
}

extension UIPasteboardViewController: UITextViewDelegate {}
