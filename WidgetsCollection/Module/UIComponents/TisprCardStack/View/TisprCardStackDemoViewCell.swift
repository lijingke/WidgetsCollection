//
//  TisprCardStackDemoViewCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/10.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class TisprCardStackDemoViewCell: CardStackViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = Constants.cellCornerRadius
        clipsToBounds = false
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(text)
        addSubview(voteSmile)

        text.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        voteSmile.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 238, height: 238))
        }
    }

    private enum Constants {
        static let cellCornerRadius: CGFloat = 12
        static let animationSpeed: Float = 0.86
        static let rotationRadius: CGFloat = 15
        static let smileNeutral = "smile_neutral"
        static let smileFace1 = "smile_face_1"
        static let smileFace2 = "smile_face_2"
        static let smileRotten1 = "smile_rotten_1"
        static let smileRotten2 = "smile_rotten_2"
    }

    override var center: CGPoint {
        didSet {
            updateSmileVote()
        }
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }

    private func updateSmileVote() {
        let smileImageName: String
        let rotation = atan2(transform.b, transform.a) * 100

        switch rotation {
        case -1 * CGFloat.greatestFiniteMagnitude ..< -1 * Constants.rotationRadius:
            smileImageName = Constants.smileRotten2
        case -1 * Constants.rotationRadius..<0:
            smileImageName = Constants.smileRotten1
        case 1..<Constants.rotationRadius:
            smileImageName = Constants.smileFace1
        case Constants.rotationRadius...CGFloat.greatestFiniteMagnitude:
            smileImageName = Constants.smileFace2
        default:
            smileImageName = Constants.smileNeutral
        }

        voteSmile.image = UIImage(named: smileImageName)
    }

    lazy var text: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var voteSmile: UIImageView = {
        let view = UIImageView()
        return view
    }()
}
