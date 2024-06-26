//
//  GestureUnlockView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/3.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class GestureUnlockView: UIView {
    /// 路径
    var path: UIBezierPath = .init()
    /// 存储已经路过的点
    var pointsArray: [CGPoint] = []
    /// 当前手指所在的点
    var fingurePoint: CGPoint!
    /// 存储的密码
    var passwordArray: [Int] = []
    /// 初次登陆时的最大输入次数
    var inputCount: Int = 0
    /// 控制是否初次登陆
    var isFirst: Bool = true
    /// 控制是否修改密码
    var isChangeGestures: Bool = false

    // MARK: - Override

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 手势密码
        gesturePasswordLayoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, changeGestures: Bool) {
        super.init(frame: frame)
        // 手势密码
        isChangeGestures = changeGestures
        gesturePasswordLayoutUI()
    }

    // MARK: - 懒加载

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    fileprivate func gesturePasswordLayoutUI() {
        backgroundColor = .white
        // 添加提示框
        addSubview(messageLabel)
        messageLabel.frame = CGRect(x: 0, y: 100, width: kScreenWidth, height: 50)
        // 添加手势密码
        gesturePasswordUI()
        // 设置path
        path.lineWidth = 2.0

        // 是否修改密码
        if isChangeGestures {
            print("这是修改密码页面")
            UserDefaults.standard.removeObject(forKey: "newPassword")
            messageLabel.text = "请输入新的手势密码"
        } else {
            print("")
            let password = UserDefaults.standard.value(forKey: "password")
            if password != nil {
                isFirst = false
                messageLabel.text = "确认手势密码"
            } else {
                messageLabel.text = "请创建手势密码"
            }
        }
    }

    fileprivate func gesturePasswordUI() {
        // 画密码
        let width: CGFloat = 60.0
        let height: CGFloat = width
        var x: CGFloat = 0
        var y: CGFloat = 0

        // 计算空隙
        let spaceWidth = (kScreenWidth - 3 * width) / 4
        let spaceHeight = (kscreenHeight - 3 * height) / 4

        for index in 0 ..< 9 {
            // 计算当前所在行
            let row = index % 3
            let line = index / 3
            // 计算坐标
            x = CGFloat(row) * width + CGFloat(row + 1) * spaceWidth
            y = CGFloat(100 * line) + spaceHeight * 2

            let button = NumberButton(frame: CGRect(x: x, y: y, width: width, height: height))
            button.tag = index
            addSubview(button)
        }
    }

    override func draw(_: CGRect) {
        path.removeAllPoints()
        for (index, point) in pointsArray.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        // 让画线跟随手指
        if fingurePoint != CGPoint.zero && pointsArray.count > 0 {
            path.addLine(to: fingurePoint)
        }
        // 设置线的颜色
        let color = UIColor.hexStringToColor(hexString: ColorOfWaveBlackColor)
        color.set()
        path.stroke()
    }
}

extension GestureUnlockView {
    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        // 每次点击移除所有存储过的点，重新统计
        pointsArray.removeAll()
        touchChanged(touches.first!)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        touchChanged(touches.first!)
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        if passwordArray.count == 0 {
            return
        }
        inputCount += 1

        // 本地存储
        let password = UserDefaults.standard.value(forKey: "password")
        let newPassword = UserDefaults.standard.value(forKey: "newPassword")

        // 修改密码界面
        if isChangeGestures {
            if newPassword != nil {
                print("输入的是什么\(passwordArray),保存的是什么\(String(describing: newPassword))")
                if Tools.passwordString(array: passwordArray as NSArray) == Tools.passwordString(array: newPassword as! NSArray) {
                    messageLabel.text = "设置成功"
                    isHidden = true
                    UserDefaults.standard.set(passwordArray, forKey: "password")
                } else {
                    if inputCount < 5 {
                        messageLabel.text = "输入错误，还可以输入\(5 - inputCount)次"
                    } else {
                        messageLabel.text = "请重置手势密码"
                        inputCount = 0
                        UserDefaults.standard.removeObject(forKey: "newPassword")
                    }
                }
            } else {
                // 初次储存新密码
                print("这是你初次存储的密码，密码是\(passwordArray)，长度是\(passwordArray.count)")
                UserDefaults.standard.set(passwordArray, forKey: "newPassword")
            }
        } else {
            // 非修改密码界面

            // 初次登陆,五次设置密码的机会
            if isFirst {
                if password != nil, (password as! NSArray).count > 0 {
                    print("输入的是什么\(passwordArray)，保存的是什么\(String(describing: newPassword))")
                    if Tools.passwordString(array: passwordArray as NSArray) == Tools.passwordString(array: password as! NSArray) {
                        messageLabel.text = "设置成功"
                        isHidden = true

                        let alertController = UIAlertController(title: "通知", message: "是否使用指纹解锁？", preferredStyle: .alert)

                        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                            print("不加入指纹解锁")
                            UserDefaults.standard.set(false, forKey: "fingerPrint")
                        }

                        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
                            print("使用指纹解锁")
                            UserDefaults.standard.set(true, forKey: "fingerPrint")
                        }
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        getViewController().present(alertController, animated: true, completion: nil)
                        print("获取到当前的控制器\(getViewController())")
                    } else {
                        if inputCount < 5 {
                            messageLabel.text = "输入错误，还可以输入\(5 - inputCount)次"
                        } else {
                            messageLabel.text = "请重置手势密码"
                            inputCount = 0
                            UserDefaults.standard.removeObject(forKey: "password")
                        }
                    }
                } else {
                    // 初次存储

                    print("这是你初次存储的密码，密码是\(passwordArray)，长度是\(passwordArray.count)")
                    messageLabel.text = "确认手势密码"
                    UserDefaults.standard.set(passwordArray, forKey: "password")
                }
            } else {
                // 非初次登陆,不可重置密码,只能一直输入

                if Tools.passwordString(array: passwordArray as NSArray) == Tools.passwordString(array: password as! NSArray) {
                    isHidden = true
                } else {
                    messageLabel.text = "输入错误"
                }
            }
        }

        // ------------------------------
        // 移除所有记录
        pointsArray.removeAll()
        passwordArray.removeAll()
        path.removeAllPoints()
        setNeedsDisplay()
        fingurePoint = .zero

        // 清除所有按钮的选中状态
        for button in subviews {
            if button.isKind(of: NumberButton.self) {
                button.backgroundColor = .clear
            }
        }
    }

    fileprivate func touchChanged(_ touch: UITouch) {
        let point = touch.location(in: self)
        fingurePoint = point

        for button in subviews {
            if button.isKind(of: NumberButton.self), !pointsArray.contains(button.center), button.frame.contains(point) {
                // 记录已经走过的点
                passwordArray.append(button.tag)
                // 记录密码
                pointsArray.append(button.center)
                // 设置按钮的背景色
                button.backgroundColor = UIColor.hexStringToColor(hexString: ColorOfBlackColor)
            }
        }

        // 会自动调用draw方法
        setNeedsDisplay()
    }
}
