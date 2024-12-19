//
//  FourDollarView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/9.
//

import Foundation

class FourDollarView: UIView {
    // MARK: Property

    public var updateBlock: (() -> ())?
    
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

    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var fourDollarDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold(17)
        return label
    }()
    
    lazy var jumpBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("更新倒计时", for: .normal)
        btn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(color: kThemeColor), for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()
}

// MARK: - UI

extension FourDollarView {
    private func setupUI() {
        addSubview(contentView)
        contentView.addSubviews([fourDollarDayLabel, jumpBtn])
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        fourDollarDayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        jumpBtn.snp.makeConstraints { make in
            make.top.equalTo(fourDollarDayLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 40))
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}

// MARK: - Event

extension FourDollarView {
    public func setupContent(_ day: Int) {
        fourDollarDayLabel.text = "距离李思源来广州还有：\(day)天"
    }
    
    @objc func btnAction(sender: UIButton) {
        updateBlock?()
    }
}
