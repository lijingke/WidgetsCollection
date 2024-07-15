//
//  ImageViewAnimationViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/23.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class ImageViewAnimationViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureData()
    }

    @objc fileprivate func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            view1.startAnimating()
        case 2:
            let im = UIImage.animatedImageNamed("voice", duration: 2)
            view2.image = im
        case 3:
            breathingAction()
        default:
            break
        }
    }

    fileprivate func show<T>(para: T) {
        print("Hello \(para)")
    }

    fileprivate func show<T, U>(name f: T, object: U) {
        print("Hello \(f)" + "\(object)")
    }

    fileprivate func breathingAction() {
        var arr = [UIImage]()
        let w: CGFloat = 18
        for i in 0 ..< 6 {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: w), false, 0)
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(UIColor.randomColor().cgColor)
            let ii = CGFloat(i)
            let rect = CGRect(x: ii, y: ii, width: w - ii * 2, height: w - ii * 2)
            context.addEllipse(in: rect)
            context.fillPath()
            let im = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            arr.append(im)
        }
        let im = UIImage.animatedImage(with: arr, duration: 0.5)
        breathingBtn.setImage(im, for: .normal)
    }

    fileprivate func configureData() {
        let rabbit = #imageLiteral(resourceName: "rabbit")
        UIGraphicsBeginImageContextWithOptions(rabbit.size, false, 0)
        let empty = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let arr = [rabbit, empty, rabbit, empty, rabbit]
        view1.animationImages = arr
        view1.animationDuration = 2
        view1.animationRepeatCount = 3

        var intArr: [Int] = [8, 2, 3, 4, 5]
        let sortArr = intArr.sorted { $0 > $1 }
        print(sortArr)

        typealias CompletionHandle = () -> Void

        let sortedDatas = intArr.sortedDatas(by: <)
        print(intArr)
        print(sortedDatas)

        let netManager = NetWorkManager()
        netManager.getUserInfo(phone: "123456", success: {
            print("刷新你的界面")
        }) { errorMessage in
            print(errorMessage)
        }
    }

    lazy var view1: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "rabbit")
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var view2: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "rabbit")
        view.backgroundColor = .randomColor()
        return view
    }()

    lazy var btn1: UIButton = {
        let btn = UIButton()
        btn.setTitle("ImageView Animation", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var btn2: UIButton = {
        let btn = UIButton()
        btn.setTitle("Imageview Animation1", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.tag = 2
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()

    lazy var breathingBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Touch Me", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.layer.backgroundColor = UIColor.randomColor().cgColor
        btn.tag = 3
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        return btn
    }()
}

private extension ImageViewAnimationViewController {
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(breathingBtn)

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

        breathingBtn.snp.makeConstraints { make in
            make.top.equalTo(btn2.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
    }
}

extension Array {
    mutating func sortedDatas(by: (Element, Element) -> Bool) -> [Element] {
        for i in 0 ... count - 1 {
            for j in i ... count - 1 {
                if by(self[i], self[j]) {
                    (self[i], self[j]) = (self[j], self[i])
                }
            }
        }
        return self
    }
}

class NetWorkManager {
    func getUserInfo(phone: String?, success: @escaping (() -> Void), failure: (_ errorMessage: String) -> Void) {
        print("函数开始执行")
        guard let _ = phone else {
            print("执行了failure闭包")
            failure("电话号码不能为空")
            return
        }
        // 用来模拟网络请求
        let dataTask = URLSession.shared.dataTask(with: URL(string: "https://www.baidu.com")!) { _, _, _ in
            print("执行了Success闭包")
            success()
        }
        dataTask.resume()
        print("函数执行结束")
    }
}

class Person: NSObject {
    var name: String
    init(name: String) {
        print("init 的方法的实现")
        self.name = name
    }
}
