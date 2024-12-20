//
//  InfoListView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/4.
//

import Foundation
import UIKit
import ZhuoZhuo

class InfoListView: UIView {
    // MARK: Property

    private var dataSource: [ResponseModel] = []

    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lazy Get

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
        table.dataSource = self
        table.delegate = self
        return table
    }()
}

// MARK: - Data

extension InfoListView {
    public func setupData(_ data: [ResponseModel]) {
        dataSource = data
        tableView.reloadData()
    }
}

// MARK: - UI

extension InfoListView {
    private func setupUI() {
        addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDelegate

extension InfoListView: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension InfoListView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
        let model = dataSource[indexPath.row]
        cell.setupData(model)
        return cell
    }
}
