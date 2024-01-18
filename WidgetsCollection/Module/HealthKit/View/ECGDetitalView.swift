//
//  ECGDetitalView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation
import UIKit

protocol ECGDetitalViewDelegate: NSObjectProtocol {
    
}

class ECGDetitalView: UIView {
    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy Get
    
    lazy var ecgChartView: ECGChartView = {
        let view = ECGChartView()
        return view
    }()
    
    lazy var sampleDetailView: ECGSampleDetailView = {
        let view = ECGSampleDetailView()
        return view
    }()
}

// MARK: - Data
extension ECGDetitalView {
    public func refreshData(model: ECGModel) {
        ecgChartView.refresh(model: model)
        sampleDetailView.refreshData(model)
    }
}

// MARK: - UI
extension ECGDetitalView {
    private func setupUI() {
        backgroundColor = UIColor(hexString: "#F6F7F8")
        addSubviews([ecgChartView, sampleDetailView])
        ecgChartView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        sampleDetailView.snp.makeConstraints { make in
            make.top.equalTo(ecgChartView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

