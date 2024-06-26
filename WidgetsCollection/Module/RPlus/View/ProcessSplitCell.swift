//
//  ProcessSplitCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/10/11.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import UIKit

class ProcessSplitCell: UITableViewCell {
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

    // MARK: Lazy Get

    lazy var splitLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#FF6770")
        return line
    }()
}

extension ProcessSplitCell {
    public func setupType(isFinished: Bool) {
        splitLine.backgroundColor = isFinished ? UIColor(hexString: "#FF6770") : UIColor(hexString: "#C0C3CE")
    }
}

// MARK: - UI

extension ProcessSplitCell {
    private func setupUI() {
        contentView.addSubview(splitLine)
        splitLine.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.size.equalTo(CGSize(width: 1, height: 32))
        }
    }
}
