//
//  RefreshView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/8/3.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation
import MJRefresh

class RefreshView: UIView {
    
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
        table.separatorStyle = .none
        table.register(RefreshCell.self, forCellReuseIdentifier: RefreshCell.identifier)
        return table
    }()
}

extension RefreshView {
    private func setupUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let header = MJRefreshGifHeader()
        header.refreshingBlock = {
            print("refresh")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableView.mj_header?.endRefreshing()
            }
        }
        header.setImages([UIImage(named: "arrow_up")!, UIImage(named: "arrow_down")!], for: .idle)
        tableView.mj_header = header
        header.beginRefreshing()
        header.isAutomaticallyChangeAlpha = true
        
        let footer = MJRefreshAutoGifFooter()
        footer.setImages([UIImage(named: "arrow_up")!, UIImage(named: "arrow_down")!], for: .noMoreData)
        footer.refreshingBlock = {
            print("refresh")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.tableView.mj_footer?.endRefreshing()
                self.tableView.mj_footer?.state = .noMoreData
            }
        }
        
        tableView.mj_footer = footer
    }
}

// MARK: - UITableViewDataSource
extension RefreshView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RefreshCell.identifier, for: indexPath) as? RefreshCell else { return UITableViewCell() }
        cell.textLabel?.text = "\(indexPath.description)"
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension RefreshView: UITableViewDelegate {
    
}
