//
//  ProcessProgressView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/11.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import UIKit

class ProcessProgressView: UIView {
    // MARK: Property
    private var dataSource: [ProcessModel] = []
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy Get
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(ProcessCompletedCell.self, forCellReuseIdentifier: ProcessCompletedCell.identifier)
        table.register(ProcessUncompletedCell.self, forCellReuseIdentifier: ProcessUncompletedCell.identifier)
        table.register(ProcessInProgressCell.self, forCellReuseIdentifier: ProcessInProgressCell.identifier)
        table.register(ProcessHintCell.self, forCellReuseIdentifier: ProcessHintCell.identifier)
        table.register(ProcessSplitCell.self, forCellReuseIdentifier: ProcessSplitCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
}

// MARK: - Data
extension ProcessProgressView {
    public func setupData(_ dataSource: [ProcessModel]) {
        self.dataSource = dataSource
        tableView.reloadData()
    }
}

// MARK: - UI
extension ProcessProgressView {
    private func setupUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate
extension ProcessProgressView: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension ProcessProgressView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        switch model.type {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProcessCompletedCell.identifier, for: indexPath) as! ProcessCompletedCell
            cell.setupData(title: model.title, canEdit: model.canEdit)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProcessInProgressCell.identifier, for: indexPath) as! ProcessInProgressCell
            cell.setupData(title: model.title, hint: model.inProcessHint)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProcessUncompletedCell.identifier, for: indexPath) as! ProcessUncompletedCell
            cell.setupData(title: model.title)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProcessHintCell.identifier, for: indexPath) as! ProcessHintCell
            cell.setupData(model.tipsContent ?? "")
            return cell
        case 5, 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProcessSplitCell.identifier, for: indexPath) as! ProcessSplitCell
            cell.setupType(isFinished: model.type == 5)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
