//
//  ChatFilterView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/31.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class ChatFilterView: UIView {
    weak var delegate: ChatFilterEventProtocol?

    var defaultTags: [tagViewModel] = []
    var customMembers: [String] = []
    var customTags: [String] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configureUI() {
        addSubview(tableView)
        addSubview(leftResetBtn)
        addSubview(rightConfirmBtn)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(leftResetBtn.snp.top)
        }
        leftResetBtn.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(50)
        }

        rightConfirmBtn.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.width.height.equalTo(leftResetBtn)
        }
    }

    public func configureData(defultTags: [tagViewModel], customTags: [String], customMembers: [String]) {
        defaultTags = defultTags
        self.customTags = customTags
        self.customMembers = customMembers
        tableView.reloadData()
    }

    // MARK: - ButtonClickEvent

    @objc func confirmAction() {
        let choosedTags = defaultTags.filter { $0.isSelected == true }
        delegate?.confirmAction(choosedDefultTags: choosedTags, customMembers: customMembers, customTags: customTags)
    }

    @objc func resetInput() {
        customMembers.removeAll()
        customTags.removeAll()
        let revertData = defaultTags.compactMap { tagModel -> tagViewModel? in
            var model = tagModel
            model.isSelected = false
            return model
        }

        defaultTags = revertData
        tableView.reloadData()
    }

    // MARK: - Lazy Get

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CommonInputCell.self, forCellReuseIdentifier: CommonInputCell.reuseId)
        table.register(CommonAddCell.self, forCellReuseIdentifier: CommonAddCell.reuseId)
        table.register(ChatFilterTagCell.self, forCellReuseIdentifier: ChatFilterTagCell.reuseId)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.delegate = self
        table.dataSource = self
        return table
    }()

    lazy var leftResetBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor(hex: 0x4099FF), for: .normal)
        btn.setTitle("重置", for: .normal)
        btn.titleLabel?.font = UIFont.medium(18)
        btn.backgroundColor = .white
        btn.tag = 0
        btn.addTarget(self, action: #selector(resetInput), for: .touchDown)
        return btn
    }()

    lazy var rightConfirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor(hex: 0xFFFFFF), for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.medium(18)
        btn.backgroundColor = UIColor(hex: 0x4099FF)
        btn.tag = 1
        btn.addTarget(self, action: #selector(confirmAction), for: .touchDown)
        return btn
    }()
}

// MARK: - UITableViewDelegate

extension ChatFilterView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            customMembers.append("")
            tableView.endUpdates()
        } else if indexPath.section == 2 {
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            customTags.append("")
            tableView.endUpdates()
        }
    }
}

// MARK: - UITableViewDataSource

extension ChatFilterView: UITableViewDataSource {
    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FilterViewHeadCell()
        let sectionTitles = ["成员", "标签", "标签"]
        view.setTitle(sectionTitles[section])
        return view
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 46
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 3
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return customMembers.count + 1
        case 1:
            return 1
        case 2:
            return customTags.count + 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == customMembers.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonAddCell.reuseId, for: indexPath) as? CommonAddCell else { return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonInputCell.reuseId, for: indexPath) as? CommonInputCell else { return UITableViewCell() }
                cell.placeHolder = "请输入聊天成员ID"
                cell.inputField.text = customMembers[indexPath.row]
                cell.inputBlock = { [weak self] input in
                    self?.customMembers[indexPath.row] = input
                    print(input)
                }
                return cell
            }
        }

        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatFilterTagCell.reuseId, for: indexPath) as? ChatFilterTagCell else { return UITableViewCell() }
            cell.delegate = self
            cell.tags = defaultTags
            cell.refreshAction = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
        }

        if indexPath.section == 2 {
            if indexPath.row == customTags.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonAddCell.reuseId, for: indexPath) as? CommonAddCell else { return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonInputCell.reuseId, for: indexPath) as? CommonInputCell else { return UITableViewCell() }
                cell.placeHolder = "请输入标签名称"
                cell.inputField.text = customTags[indexPath.row]
                cell.inputBlock = { [weak self] input in
                    self?.customTags[indexPath.row] = input
                }
                return cell
            }
        }

        return UITableViewCell()
    }
}

// MARK: - ChatFilterEventProtocol

extension ChatFilterView: ChatFilterEventProtocol {
    func tagChoosed(atInsexPath: IndexPath, tag: tagViewModel) {
        defaultTags[atInsexPath.row] = tag
    }
}
