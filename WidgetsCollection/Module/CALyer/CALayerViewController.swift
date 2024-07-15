//
//  CALayerViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/23.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class CALayerViewController: BaseViewController {
    let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layer = CALayer()
        layer.contents = #imageLiteral(resourceName: "star").cgImage
        layer.contentsScale = #imageLiteral(resourceName: "star").scale
        layer.frame = view5.bounds
        view5.layer.mask = layer
        configureShapeLayer()
    }

    fileprivate func configureData() {
        view1.layer.contents = #imageLiteral(resourceName: "rabbit").cgImage
        view1.layer.contentsGravity = .top
        view1.layer.contentsRect = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)

        view3.layer.position = CGPoint.zero
        view3.layer.anchorPoint = CGPoint.zero

        clockView.backgroundColor = .clear
        clockView.layer.contents = #imageLiteral(resourceName: "clock").cgImage
        clockView.layer.contentsScale = #imageLiteral(resourceName: "clock").scale

        arrowView.layer.contents = #imageLiteral(resourceName: "arrow").cgImage
        arrowView.layer.contentsScale = #imageLiteral(resourceName: "arrow").scale
        arrowView.layer.backgroundColor = UIColor.clear.cgColor
        arrowView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        let opts: UIView.AnimationOptions = [.autoreverse, .repeat]
        UIView.animate(withDuration: 1, delay: 0, options: opts, animations: {
            self.arrowView.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 2)
        }, completion: nil)

        view4.backgroundColor = .white
        view4.layer.shadowColor = UIColor.black.cgColor
        view4.layer.shadowOffset = CGSize(width: 0, height: 3)
        view4.layer.shadowOpacity = 0.6
        view4.layer.shadowRadius = 10
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        transform = CATransform3DRotate(transform, CGFloat.pi / 4, 0, 1, 0)
        view4.layer.transform = transform

        view5.backgroundColor = .clear
        view5.layer.contents = #imageLiteral(resourceName: "cat").cgImage
        view5.layer.contentsScale = #imageLiteral(resourceName: "cat").scale
    }

    fileprivate func configureShapeLayer() {
        let rect = view7.bounds
        let path = UIBezierPath(ovalIn: rect)
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.randomColor().cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.frame = view7.bounds
        view7.layer.addSublayer(shapeLayer)
    }

    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.view1, self.view2, self.view3])
        view.axis = .horizontal
        view.spacing = 30
        view.distribution = .fillEqually
        return view
    }()

    lazy var view1: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var view2: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var view3: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var clockView: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var arrowView: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var view4: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var view5: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var view6: CustomView = {
        let view = CustomView()
        return view
    }()

    lazy var view7: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()
}

private extension CALayerViewController {
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(clockView)
        clockView.addSubview(arrowView)
        view.addSubview(view4)
        view.addSubview(view5)
        view.addSubview(view6)
        view.addSubview(view7)

        stackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(100)
        }

        clockView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(133)
        }

        arrowView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 6, height: 48))
            make.center.equalToSuperview()
        }

        view5.snp.makeConstraints { make in
            make.top.equalTo(clockView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }

        view4.snp.makeConstraints { make in
            make.size.equalTo(view5)
            make.centerY.equalTo(view5)
            make.right.equalTo(view5.snp.left).offset(-30)
        }

        view6.snp.makeConstraints { make in
            make.size.equalTo(view5)
            make.centerY.equalTo(view5)
            make.left.equalTo(view5.snp.right).offset(30)
        }

        view7.snp.makeConstraints { make in
            make.top.equalTo(view5.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(143)
        }
    }
}

class CustomView: UIView {
    let view = UIView()

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareView()
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func prepareView() {
        if let gradientLayer = layer as? CAGradientLayer {
            gradientLayer.colors = [UIColor.randomColor().cgColor, UIColor.randomColor().cgColor]
            gradientLayer.startPoint = CGPoint.zero
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
    }
}
