//
//  ProcessProgressVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/11.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation

class ProcessProgressVC: UIViewController {
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    // MARK: Lazy Get

    lazy var mainView: ProcessProgressView = {
        let view = ProcessProgressView()
        return view
    }()
}

// MARK: - DataSource

extension ProcessProgressVC {
    private func setupData() {
        let dic: [[String: Any]] = [["type": 1, "title": "个人信息"], ["type": 1, "title": "诊断信息", "canEdit": true], ["type": 2, "title": "激活服务", "inProcessHint": "等待医生确认"], ["type": 3, "title": "关联医生"], ["type": 4, "tipsContent": "您目前的情况不适合线上评估，建议至医院/诊所进行更详细的肺功能筛查。同时请等待医生为您定制处方，医生发送处方后可以开始运动"] ]
        let dataSource = dic.compactMap({ProcessModel.deserialize(from: $0)})
        
        var resData: [ProcessModel] = []
        for i in 0..<dataSource.count {
            resData.append(dataSource[i])
            if i == 0 {
                continue
            }
            switch dataSource[i].type {
            case 1, 2:
                var entity = ProcessModel()
                entity.type = 5
                resData.insert(entity, at: resData.count - 1)
            case 3:
                var entity = ProcessModel()
                entity.type = 6
                resData.insert(entity, at: resData.count - 1)
            default:
                break
            }
        }

        mainView.setupData(resData)
    }
}

// MARK: - UI

extension ProcessProgressVC {
    private func setupUI() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
