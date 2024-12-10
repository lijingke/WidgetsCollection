//
//  MineView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/23.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

class MineView: UIView {
    private var dataSource: [MineCellModel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.tableHeaderView = self.headView
        table.delegate = self
        table.dataSource = self
        return table
    }()

    lazy var headView: UserInfoHeadView = {
        let view = UserInfoHeadView()
        view.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return view
    }()
}

// MARK: - UI

extension MineView {
    private func setupUI() {
        addSubview(tableView)
        tableView.addSubview(headView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.setNeedsLayout()
        layoutIfNeeded()
    }

    /// 刷新table
    /// - Parameter dataSource: 数据源
    public func setupData(_ dataSource: [MineCellModel]) {
        self.dataSource = dataSource
        tableView.reloadData()
    }

    public func setupUserInfo(_ model: UserInfoModel?) {
        headView.setupData(model)
    }
}

// MARK: - UITableViewDataSource

extension MineView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dataSource.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = "Setting"
        cell.textLabel?.text = model.title
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: model.imageName ?? "") ?? UIImage(systemName: model.imageName ?? "")
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MineView: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        item.tap?()
    }
}
