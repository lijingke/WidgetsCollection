//
//  FourDollarView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/9.
//

import Foundation

class FourDollarView: UIView {
    // MARK: Property
    public var updateBlock: (()->())?
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy Get
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
        addSubviews([fourDollarDayLabel, jumpBtn])
        fourDollarDayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        jumpBtn.snp.makeConstraints { make in
            make.top.equalTo(fourDollarDayLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 50))
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Event
extension FourDollarView {
    
    public func setupContent(_ content: String) {
        fourDollarDayLabel.text = content
    }
    
    @objc func btnAction(sender: UIButton) {
        updateBlock?()
    }
}
