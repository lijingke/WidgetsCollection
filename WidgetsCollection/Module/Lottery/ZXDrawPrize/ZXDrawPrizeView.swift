//
//  ZXDrawPrizeView.swift
//  ZXStructs
//
//  Created by JuanFelix on 2018/4/16.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

enum ZXPrizeType {
    case normal // 正常
    case drawOut // 该项奖品抽完
    case empty // 无奖品(谢谢参与)
}

class ZXPrizeModel: NSObject {
    var image: String = ""
    var type: ZXPrizeType = .empty
}

protocol ZXDrawPrizeDelegate: class {
    /// 点击抽奖按钮
    func zxDrawPrizeStartAction(prizeView: ZXDrawPrizeView)
    /// 抽奖结束
    func zxDrawPrizeEndAction(prizeView: ZXDrawPrizeView, prize index: NSInteger)
}

protocol ZXDrawPrizeDataSource: class {
    /// 奖品格子数量
    func numberOfPrize(for drawprizeView: ZXDrawPrizeView) -> NSInteger
    /// 商品图片(包括谢谢参与)
    // 本地图片(二选一 优先)
    func zxDrawPrize(prizeView: ZXDrawPrizeView, imageAt index: NSInteger) -> UIImage?
    // 网络图片(二选一)
    func zxDrawPrize(prizeView: ZXDrawPrizeView, imageUrlAt index: NSInteger) -> String?
    /// 某项奖品抽完
    func zxDrawPrize(prizeView: ZXDrawPrizeView, drawOutAt index: NSInteger) -> Bool
    /// 点击抽奖按钮
    func zxDrawPrizeButtonImage(prizeView: ZXDrawPrizeView) -> UIImage
    /// 大背景
    func zxDrawPrizeBackgroundImage(prizeView: ZXDrawPrizeView) -> UIImage?
    /// 滚动背景
    func zxDrawPrizeScrollBackgroundImage(prizeView: ZXDrawPrizeView) -> UIImage?
}

extension ZXDrawPrizeDataSource {
    func zxDrawPrize(prizeView _: ZXDrawPrizeView, imageAt _: NSInteger) -> UIImage? {
        return nil
    }

    func zxDrawPrize(prizeView _: ZXDrawPrizeView, imageUrlAt _: NSInteger) -> String? {
        return nil
    }
}

/// ZXDrawPrizeView
class ZXDrawPrizeView: UIView {
    weak var delegate: ZXDrawPrizeDelegate?
    weak var dataSource: ZXDrawPrizeDataSource? {
        didSet {
            reloadData()
        }
    }

    fileprivate var prizeIndex = -1
    fileprivate var btnStart: UIButton!

    /// 大背景图
    let bigBackImage = UIImageView()
    /// 滚动背景
    let prizeContentBackImage = UIImageView()
    /// 用于添加奖品，便于统一旋转
    let prizeContentLayer = CALayer()
    /// 大小背景边距
    let contentOffset: CGFloat = 20

    fileprivate var zx_count = 0 // 总个数（包含[谢谢参与]）

    fileprivate var zxShapeLayers: [ZXPrizeContentLayer] = []
    fileprivate var zxDrawOutValue: [Int: Bool] = [:]

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(_ origin: CGPoint, width: CGFloat) {
        self.init(frame: CGRect(x: origin.x, y: origin.y, width: width, height: width))
        backgroundColor = UIColor.clear
        clipsToBounds = false
        // self.layer.cornerRadius = width / 2

        let prizeContentWidth = width - contentOffset * 2
        ZXSectorModel.circleRadius = prizeContentWidth / 2.0
        // 大背景
        bigBackImage.frame = CGRect(x: 0, y: 0, width: width, height: width)
        bigBackImage.backgroundColor = UIColor.clear
        bigBackImage.contentMode = .scaleAspectFill

        bigBackImage.clipsToBounds = false
        bigBackImage.layer.shadowRadius = 5
        bigBackImage.layer.shadowColor = UIColor.black.cgColor
        bigBackImage.layer.shadowOffset = CGSize(width: 0, height: 5)
        bigBackImage.layer.shadowOpacity = 0.3
        // 滚动背景
        prizeContentBackImage.frame = CGRect(origin: CGPoint(x: contentOffset, y: contentOffset), size: CGSize(width: prizeContentWidth, height: prizeContentWidth))
        prizeContentBackImage.backgroundColor = UIColor.clear
        prizeContentBackImage.contentMode = .scaleAspectFill
        prizeContentBackImage.layer.cornerRadius = prizeContentWidth / 2.0
        prizeContentBackImage.layer.masksToBounds = true
        // Prize Content
        prizeContentLayer.frame = prizeContentBackImage.bounds
        prizeContentLayer.backgroundColor = UIColor.clear.cgColor

        prizeContentBackImage.layer.addSublayer(prizeContentLayer)

        addSubview(bigBackImage)
        addSubview(prizeContentBackImage)

        btnStart = UIButton(type: .custom)
        btnStart.addTarget(self, action: #selector(startDrawPrizeAction), for: .touchUpInside)
        btnStart.backgroundColor = UIColor.clear
        btnStart.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        btnStart.contentMode = .scaleAspectFill
        btnStart.contentVerticalAlignment = .fill
        btnStart.contentHorizontalAlignment = .fill
        btnStart.center = CGPoint(x: width / 2, y: width / 2)

        addSubview(btnStart)
    }

    @objc func startDrawPrizeAction() {
        reset()
        delegate?.zxDrawPrizeStartAction(prizeView: self)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() {
        if let dataSouce = dataSource {
            zx_count = dataSouce.numberOfPrize(for: self)
            if zx_count < 3 {
                fatalError("At least 3!")
            }

            ZXSectorModel.sectorCount = zx_count
            zxShapeLayers.removeAll()
            zxShapeLayers = ZXSectorModel.zxSectorLayers()

            // 旋转至垂直方向
            var transform = CATransform3DIdentity
            transform = CATransform3DMakeRotation(ZXSectorModel.sectorRadian / 2, 0, 0, 1)
            prizeContentLayer.transform = transform

            btnStart.setImage(dataSouce.zxDrawPrizeButtonImage(prizeView: self), for: .normal)

            let pLayers = prizeContentLayer.sublayers
            // if let pLayers = pLayers, pLayers.count != zx_count {//数量相同导致重复添加
            if let pLayers = pLayers {
                for sl in pLayers {
                    sl.removeFromSuperlayer()
                }
            }

            for n in 0..<zx_count {
                let tempI = (zx_count - 1 - n) // 调整顺序
                let spl = zxShapeLayers[tempI] //
                // spl.setPrizeImage(dataSouce.zxDrawPrize(prizeView: self, imageAt: tempI))
                spl.setPrizeImage(dataSouce.zxDrawPrize(prizeView: self, imageAt: tempI), url: dataSouce.zxDrawPrize(prizeView: self, imageUrlAt: tempI))
                if dataSouce.zxDrawPrize(prizeView: self, drawOutAt: tempI) {
                    spl.setMarkImage(#imageLiteral(resourceName: "drawOut"))
                } else {
                    spl.setMarkImage(nil)
                }
                prizeContentLayer.addSublayer(spl.zxshape)
            }

            bigBackImage.image = dataSouce.zxDrawPrizeBackgroundImage(prizeView: self)

            if let cbimage = dataSouce.zxDrawPrizeScrollBackgroundImage(prizeView: self) {
                prizeContentBackImage.image = cbimage
            } else {
                prizeContentBackImage.image = nil
                var index = 0
                for shape in zxShapeLayers {
                    shape.zxshape.strokeColor = UIColor.white.cgColor
                    if index % 2 == 0 {
                        shape.zxshape.fillColor = UIColor(red: 129 / 255.0, green: 203 / 255.0, blue: 1, alpha: 1).cgColor
                    } else {
                        shape.zxshape.fillColor = UIColor(red: 165 / 255.0, green: 218 / 255.0, blue: 1, alpha: 1).cgColor
                    }
                    index += 1
                }
            }
        }
    }

    /// 重置
    func reset() {
        prizeIndex = -1
        prizeContentBackImage.layer.transform = CATransform3DIdentity
    }

    /// 执行抽奖
    /// 执行抽奖
    ///
    /// - Parameters:
    ///   - index: 奖品序号
    ///   - reject: 上一次抽奖动作未结束
    func drawPrize(at index: NSInteger, reject: ((Bool) -> Void)? = nil) {
        if index < zx_count, index >= 0 {
            if is_animating {
                reject?(true)
                return
            }
            is_animating = true
            reject?(false)
            prizeIndex = (zx_count - 1 - index) // 调整顺序
            prizeContentBackImage.layer.add(rotateAnimation, forKey: "rotationAnimation")
        } else {
            fatalError("Invalid index")
        }
    }

    fileprivate var zx_animation: CABasicAnimation? = nil
    fileprivate var is_animating = false
    var rotateAnimation: CABasicAnimation {
        if zx_animation == nil {
            zx_animation = CABasicAnimation(keyPath: "transform.rotation.z")
            zx_animation?.duration = 3
            zx_animation?.isCumulative = true
            zx_animation?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            zx_animation?.fillMode = CAMediaTimingFillMode.forwards
            zx_animation?.isRemovedOnCompletion = false
            zx_animation?.delegate = self
        }
        let fix = ZXSectorModel.sectorRadian / 2
        let rotateValue = CGFloat(prizeIndex) * ZXSectorModel.sectorRadian + fix
        zx_animation?.toValue = ((CGFloat.pi * 2) * 3 + rotateValue)

        return zx_animation!
    }
}

extension ZXDrawPrizeView: CAAnimationDelegate {
    func animationDidStop(_: CAAnimation, finished _: Bool) {
        is_animating = false
        delegate?.zxDrawPrizeEndAction(prizeView: self, prize: zx_count - 1 - prizeIndex) // 调整顺序
    }
}
