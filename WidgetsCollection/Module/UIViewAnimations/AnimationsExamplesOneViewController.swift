//
//  AnimationsExamplesOneViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/22.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class AnimationsExamplesOneViewController: BaseViewController {
    lazy var effectView = UIVisualEffectView()

    var pOrig: CGPoint = .zero
    var pFinal: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureEffectView()
    }

    @objc fileprivate func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("Effect Animation")
            let effect = UIBlurEffect(style: .dark)
            effectView.effect = nil
            UIView.animate(withDuration: 1) {
                self.effectView.effect = effect
            }
        case 2:
            print("Autoreverse")
            let origX = view2.center.x
            let opts: UIView.AnimationOptions = .autoreverse
            UIView.animate(withDuration: 1, delay: 0, options: opts, animations: {
                UIView.setAnimationRepeatCount(5)
                self.view2.center.x -= 100
            }) { _ in
                self.view2.center.x = origX
            }
        case 3:
            print("Animation State")
            UIView.animate(withDuration: 0.5) {
                self.view3.center.x -= 100
            }
            UIView.animate(withDuration: 0.5) {
                self.view3.center.y += 100
            }
        case 4:
            print("Animation Start")
            pOrig = view4.center
            pFinal = view4.center
            pFinal.x -= 100
            UIView.animate(withDuration: 4) {
                self.view4.center = self.pFinal
            }
        case 5:
            print("Animation Cancel")
            view4.layer.position = view4.layer.presentation()!.position
            view4.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.1) {
                self.view4.center = self.pFinal
            }
        case 6:
            print("Transform")
            UIView.animate(withDuration: 1.2) {
                self.view5.transform = CGAffineTransform.identity.translatedBy(x: -100, y: 0).rotated(by: CGFloat.pi / 4).scaledBy(x: 0.5, y: 0.5)
            }
        default:
            break
        }
    }

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

    lazy var btn1: UIButton = {
        let btn = UIButton()
        btn.setTitle("Effect Animation", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn2: UIButton = {
        let btn = UIButton()
        btn.setTitle("Autoreverse", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 2
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn3: UIButton = {
        let btn = UIButton()
        btn.setTitle("Animation State", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 3
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn4: UIButton = {
        let btn = UIButton()
        btn.setTitle("Animation Start", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 4
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn5: UIButton = {
        let btn = UIButton()
        btn.setTitle("Animation Cancel", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 5
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn6: UIButton = {
        let btn = UIButton()
        btn.setTitle("Transform", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 6
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()
}

private extension AnimationsExamplesOneViewController {
    func configureEffectView() {
        view1.addSubview(effectView)
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        view.backgroundColor = .white

        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)
        view.addSubview(view4)
        view.addSubview(view5)
        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btn3)
        view.addSubview(btn4)
        view.addSubview(btn5)
        view.addSubview(btn6)

        view1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(80)
        }

        btn1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalTo(view1)
        }

        view2.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom).offset(15)
            make.right.size.equalTo(view1)
        }

        btn2.snp.makeConstraints { make in
            make.left.equalTo(btn1)
            make.centerY.equalTo(view2)
        }

        view3.snp.makeConstraints { make in
            make.top.equalTo(view2.snp.bottom).offset(15)
            make.right.size.equalTo(view2)
        }

        btn3.snp.makeConstraints { make in
            make.left.equalTo(btn2)
            make.centerY.equalTo(view3)
        }

        view4.snp.makeConstraints { make in
            make.top.equalTo(view3.snp.bottom).offset(15)
            make.right.size.equalTo(view3)
        }

        btn4.snp.makeConstraints { make in
            make.left.equalTo(btn3)
            make.top.equalTo(view4)
        }

        btn5.snp.makeConstraints { make in
            make.left.equalTo(btn3)
            make.bottom.equalTo(view4)
        }

        view5.snp.makeConstraints { make in
            make.top.equalTo(view4.snp.bottom).offset(15)
            make.right.size.equalTo(view4)
        }

        btn6.snp.makeConstraints { make in
            make.left.equalTo(btn5)
            make.centerY.equalTo(view5)
        }
    }
}
