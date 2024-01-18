//
//  ECGSampleDetailView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import UIKit

class ECGSampleDetailView: UIView {
    
    // MARK: Property
    private var model: ECGModel?
    
    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SAMPLE DETAILS"
        label.font = UIFont.regular(16)
        label.textColor = UIColor(hexString: "#2A2B2F")
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 68
        table.register(ECGSampleDetailCell.self, forCellReuseIdentifier: ECGSampleDetailCell.identifier)
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        table.layoutMargins = .init(top: 0.0, left: 15, bottom: 0.0, right: 15)

        return table
    }()
}

// MARK: - Data

extension ECGSampleDetailView {
    public func refreshData(_ model: ECGModel) {
        self.model = model
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension ECGSampleDetailView {
    private func setupUI() {
        addSubviews([titleLabel, tableView])
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(15)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

// MARK: - UITableViewDelegate

extension ECGSampleDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

// MARK: - UITableViewDataSource

extension ECGSampleDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ECGSampleDetailCell.identifier, for: indexPath) as! ECGSampleDetailCell
        switch indexPath.row {
        case 0:
            let dateStr = DateUtil.getDateStr(interval: model?.startTimeStamp ?? 0, format: "MMM dd, yyyy")
            let timeStr = DateUtil.getDateStr(interval: model?.startTimeStamp ?? 0, format: "KK:mm:ss aa")
            let content = "\(dateStr) at \(timeStr)"
            cell.setup(title: "Start Time", detail: content)
        case 1:
            let dateStr = DateUtil.getDateStr(interval: model?.endTimeStamp ?? 0, format: "MMM dd, yyyy")
            let timeStr = DateUtil.getDateStr(interval: model?.endTimeStamp ?? 0, format: "KK:mm:ss aa")
            let content = "\(dateStr) at \(timeStr)"
            cell.setup(title: "End Time", detail: content)
        case 2:
            cell.setup(title: "Sourse", detail: model?.sourceDevice)
        default:
            break
        }
        return cell
    }
}
