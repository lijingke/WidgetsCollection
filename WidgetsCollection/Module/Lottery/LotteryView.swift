//
//  LotteryView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2021/12/31.
//  Copyright © 2021 李京珂. All rights reserved.
//

import Foundation
import UIKit

class LotteryView: UIView {
    
    // MARK: Property
    var drawEnd = true
    private let fireworkController = ClassicFireworkController()
        
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
    
    lazy var dataSource: [RPlusInfoModel] = {
        guard let path = Bundle.main.path(forResource: "userInfo", ofType: "json") else { return [] }
        let localData = NSData(contentsOfFile: path)! as Data
        let data = localData.toDic()
        let arrayData = data["items"] as? [[String: Any]]
        let arr = arrayData?.compactMap { RPlusInfoModel.deserialize(from: $0) } ?? []
        return arr
    }()
    
    lazy var drawPrizeView: ZXDrawPrizeView = {
        let offset: CGFloat = 30
        let contentWidth: CGFloat = UIScreen.main.bounds.size.width - offset * 2
        let view = ZXDrawPrizeView(CGPoint(x: offset, y: (UIScreen.main.bounds.size.height - contentWidth) / 2 - 130), width: contentWidth)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(21)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "猜猜会是谁呢？"
        label.textAlignment = .center
        return label
    }()
    
    lazy var prizeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(19)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#CF3125")
        return label
    }()
    
    lazy var avatarImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
}

extension LotteryView {
    private func setupUI() {
        layer.contents = R.image.bg()!.cgImage
        addSubview(drawPrizeView)
        addSubviews([drawPrizeView, titleLabel, prizeInfoLabel, avatarImage])
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(drawPrizeView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        avatarImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        prizeInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func refreshUI(award: RPlusInfoModel) {
        titleLabel.text = "恭喜！\n2022年第一周的幸运星是："
        avatarImage.image = UIImage(named: "\(award.userId!)")!
        prizeInfoLabel.text = award.name
//        fireworkController.addFireworks(count: 10, sparks: 8, around: prizeInfoLabel, sparkSize: CGSize(width: 7, height: 7), scale: 45.0, maxVectorChange: 15.0, animationDuration: 3.0, canChangeZIndex: true)
        fireworkController.addFireworks(count: 10, sparks: 8, around: avatarImage, sparkSize: CGSize(width: 7, height: 7), scale: 45.0, maxVectorChange: 15.0, animationDuration: 3.0, canChangeZIndex: true)
    }
}

// MARK: - ZXDrawPrizeDataSource

extension LotteryView: ZXDrawPrizeDataSource {
    /// 各项奖品图片 (二选一，优先)
    func zxDrawPrize(prizeView: ZXDrawPrizeView, imageAt index: NSInteger) -> UIImage? {
        return UIImage(named: "WeChat_Avatar_\(index + 1)")!
    }
    
    /// 各项奖品图片 url (二选一)
    func zxDrawPrize(prizeView: ZXDrawPrizeView, imageUrlAt index: NSInteger) -> String? {
        return nil
    }
    
    /// 奖品格子数，不得小于三个
    func numberOfPrize(for drawprizeView: ZXDrawPrizeView) -> NSInteger {
        return dataSource.count
    }
    
    /// 某一项奖品抽完（不需要，直接return false 即可）
    func zxDrawPrize(prizeView: ZXDrawPrizeView, drawOutAt index: NSInteger) -> Bool {
        return false
    }

    /// 指针图片
    func zxDrawPrizeButtonImage(prizeView: ZXDrawPrizeView) -> UIImage {
        return #imageLiteral(resourceName: "Pointer")
    }

    /// 大背景
    func zxDrawPrizeBackgroundImage(prizeView: ZXDrawPrizeView) -> UIImage? {
        return #imageLiteral(resourceName: "turntableBg")
    }

    /// 滚动背景 （if nil , fill with color）
    func zxDrawPrizeScrollBackgroundImage(prizeView: ZXDrawPrizeView) -> UIImage? {
        return nil
    }
}

// MARK: - ZXDrawPrizeDelegate

extension LotteryView: ZXDrawPrizeDelegate {
    /// 点击抽奖按钮
    func zxDrawPrizeStartAction(prizeView: ZXDrawPrizeView) {
        // 这里是本地测试的 随机 奖品 index
        // 具体可根据业务数据，定位到index (顺时针顺序)
        let prizeIndex = Int(arc4random() % UInt32(dataSource.count))
        print("random index:\(prizeIndex)")
        // 执行动画
        drawPrizeView.drawPrize(at: NSInteger(prizeIndex), reject: {
            [unowned self] reject in
            if !reject {
                self.drawEnd = false
            }
        })
        // 不关注是否正在执行动画，直接调用这个
        // self.drawPrizeView.drawPrize(at: NSInteger(prizeIndex))
    }

    /// 动画执行结束
    func zxDrawPrizeEndAction(prizeView: ZXDrawPrizeView, prize index: NSInteger) {
        // 本地测试
        drawEnd = true
        let data = dataSource[index]
        refreshUI(award: data)
    }
}
