
//
//  AnimationsExamplesTwoViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/22.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class AnimationsExamplesTwoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }

    @objc fileprivate func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            UIView.animate(withDuration: 0.4) {
                self.view1.swing.toggle()
            }
        case 2:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 8, options: [], animations: {
                self.view2.center.x -= 100
            }, completion: nil)
        case 3:
            var p = view3.center
            let dur = 0.25
            var start = 0.0
            let dx: CGFloat = -100
            let dy: CGFloat = 50
            var dir: CGFloat = 1

            UIView.animateKeyframes(withDuration: 4, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: dur) {
                    p.x += dx * dir
                    p.y += dy
                    self.view3.center = p
                }
                start += dur
                dir *= -1

                UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: dur) {
                    p.x += dx * dir
                    p.y += dy
                    self.view3.center = p
                }
                start += dur
                dir *= -1

                UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: dur) {
                    p.x += dx * dir
                    p.y += dy
                    self.view3.center = p
                }
                start += dur
                dir *= -1
                UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: dur) {
                    p.x += dx * dir
                    p.y += dy
                    self.view3.center = p
                }
            }, completion: nil)
        case 4:
            UIView.transition(with: view4, duration: 0.6, options: .transitionFlipFromLeft, animations: {
                if self.view4.image == UIImage(named: "rabbit") {
                    self.view4.image = UIImage(named: "elephant")
                } else {
                    self.view4.image = UIImage(named: "rabbit")
                }
            }, completion: nil)
        case 5:
            view5.reverse.toggle()
            UIView.transition(with: view5, duration: 0.6, options: .transitionFlipFromLeft, animations: {
                self.view5.setNeedsDisplay()
            }, completion: nil)
        case 6:
            let label2 = UILabel(frame: transitionLabel.frame)
            label2.text = transitionLabel.text == "Hello" ? "World" : "Hello"
            label2.textColor = .white
            label2.sizeToFit()
            UIView.transition(from: transitionLabel, to: label2, duration: 0.8, options: .transitionFlipFromLeft) { _ in
                self.transitionLabel = label2
            }
        default:
            break
        }
    }

    lazy var view1: MyView = {
        let view = MyView()
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

    lazy var view4: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "rabbit")
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var view5: MyView1 = {
        let view = MyView1()
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var view6: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var btn1: UIButton = {
        let btn = UIButton()
        btn.setTitle("Swing Animation", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn2: UIButton = {
        let btn = UIButton()
        btn.setTitle("Spring Animation", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 2
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn3: UIButton = {
        let btn = UIButton()
        btn.setTitle("KeyFrame Animation", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 3
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn4: UIButton = {
        let btn = UIButton()
        btn.setTitle("Transition Animation", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 4
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn5: UIButton = {
        let btn = UIButton()
        btn.setTitle("Transition Animation1", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 5
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn6: UIButton = {
        let btn = UIButton()
        btn.setTitle("Transition Animation2", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 6
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var transitionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Hello"
        return label
    }()
}

private extension AnimationsExamplesTwoViewController {
    func configureUI() {
        view.backgroundColor = .white

        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)
        view.addSubview(view4)
        view.addSubview(view5)
        view.addSubview(view6)

        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btn3)
        view.addSubview(btn4)
        view.addSubview(btn5)
        view.addSubview(btn6)

        view6.addSubview(transitionLabel)

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
            make.centerY.equalTo(view4)
        }

        view5.snp.makeConstraints { make in
            make.top.equalTo(view4.snp.bottom).offset(15)
            make.right.size.equalTo(view4)
        }

        btn5.snp.makeConstraints { make in
            make.left.equalTo(btn4)
            make.centerY.equalTo(view5)
        }

        view6.snp.makeConstraints { make in
            make.top.equalTo(view5.snp.bottom).offset(15)
            make.right.size.equalTo(view5)
        }

        btn6.snp.makeConstraints { make in
            make.left.equalTo(btn5)
            make.centerY.equalTo(view6)
        }

        transitionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

class MyView: UIView {
    var swing: Bool = true {
        didSet {
            var p = center
            p.x = swing ? p.x + 100 : p.x - 100
            UIView.animate(withDuration: 0) {
                self.center = p
            }
        }
    }
}

class MyView1: UIView {
    var reverse = false
    override func draw(_: CGRect) {
        let f = bounds.insetBy(dx: 10, dy: 10)
        let context = UIGraphicsGetCurrentContext()
        if reverse {
            context?.strokeEllipse(in: f)
        } else {
            context?.stroke(f)
        }
    }
}
