//
//  InfoCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/4.
//

import Foundation
import UIKit
import ZhuoZhuo

class InfoCell: UITableViewCell {
    // MARK: Property

    var linkDic: [String: String] = [:]

    // MARK: Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: Lazy Get

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click(tap:))))
        label.numberOfLines = 0
        return label
    }()

    lazy var picView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// MARK: - Event

extension InfoCell {
    @objc func click(tap: UITapGestureRecognizer) {
        tap.didTapLabelAttributedText(linkDic) { _, url in
            if let url = URL(string: url ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

// MARK: - Data

extension InfoCell {
    public func setupData(_ model: ResponseModel) {
        titleLabel.text = model.title
        let content = model.context ?? ""
        let attContent = NSMutableAttributedString(string: model.context)
        attContent.addAttributes([.font: UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: content.count))
        let targetArr = model.clickInfoList
        _ = targetArr?.compactMap { info in
            linkDic[info.targetString] = info.url
            if let firstRange = content.exMatchStrNSRange(matchStr: info.targetString).first {
                attContent.addAttribute(.link, value: info.url ?? "", range: firstRange)
            }
        }
        contentLabel.attributedText = attContent
        picView.setWebImage(url: model.imageUrl, defaultImage: nil, isCache: true)
        picView.widthAnchor.constraint(equalToConstant: CGFloat(model.imageSizeInfo.width)).isActive = true
        picView.heightAnchor.constraint(equalToConstant: CGFloat(model.imageSizeInfo.height)).isActive = true
    }
}

// MARK: - UI

extension InfoCell {
    private func setupUI() {
        contentView.addSubview(picView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        picView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        picView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: picView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
}
