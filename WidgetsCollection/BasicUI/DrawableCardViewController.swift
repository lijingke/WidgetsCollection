//
//  DrawableCardViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/8.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

class DrawableCardViewController: UIViewController {
    
    let count = 6
    var cardView: CardView!
    var startButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        addCardView()
        view.bringSubviewToFront(reloadBtn)
    }
    
    fileprivate func setupUI() {
        view.addSubview(revokeBtn)
        view.addSubview(skipBtn)
        view.addSubview(reloadBtn)
        
        revokeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        skipBtn.snp.makeConstraints { (make) in
            make.top.equalTo(revokeBtn)
            make.right.equalToSuperview().offset(-10)
        }
        
        reloadBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        
        view.addSubview(autoReloadSwitch)
        view.addSubview(overlapSwitch)
        view.addSubview(skipAnimateSwitch)
        
        view.addSubview(autoReloadLabel)
        view.addSubview(overlapLabel)
        view.addSubview(animateLabel)
        
        autoReloadSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(overlapSwitch)
            make.left.equalTo(revokeBtn)
        }
        
        autoReloadLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(autoReloadSwitch)
            make.top.equalTo(autoReloadSwitch.snp.bottom)
        }
        
        overlapSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(revokeBtn.snp.bottom)
            make.centerX.equalToSuperview()
        }
        overlapLabel.snp.makeConstraints { (make) in
            make.top.equalTo(overlapSwitch.snp.bottom)
            make.centerX.equalTo(overlapSwitch)
        }
        
        skipAnimateSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(overlapSwitch)
            make.right.equalTo(skipBtn)
        }
        animateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(skipAnimateSwitch.snp.bottom)
            make.centerX.equalTo(skipAnimateSwitch)
        }
    }
    
    // MARK: - 懒加载
    
    lazy var revokeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 100
        btn.setTitle("Revoke", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var skipBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 101
        btn.setTitle("Skip", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var reloadBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 102
        btn.setTitle("reload", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    lazy var autoReloadSwitch: UISwitch = {
        let view = UISwitch()
        view.tag = 100
        view.addTarget(self, action: #selector(self.switchChangedAction(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var overlapSwitch: UISwitch = {
        let view = UISwitch()
        view.tag = 101
        view.addTarget(self, action: #selector(self.switchChangedAction(_:)), for: .valueChanged)
        return view
    }()
    
    
    lazy var skipAnimateSwitch: UISwitch = {
        let view = UISwitch()
        view.tag = 102
        view.addTarget(self, action: #selector(self.switchChangedAction(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var autoReloadLabel: UILabel = {
        let label = UILabel()
        label.text = "auto reload"
        label.font = UIFont.regular(12)
        label.textColor = .gray
        return label
    }()
    
    lazy var overlapLabel: UILabel = {
        let label = UILabel()
        label.text = "overlap"
        label.font = UIFont.regular(12)
        label.textColor = .gray
        return label
    }()
    
    lazy var animateLabel: UILabel = {
        let label = UILabel()
        label.text = "animate"
        label.font = UIFont.regular(12)
        label.textColor = .gray
        return label
    }()
    
    fileprivate func addCardView() {
        cardView = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        cardView.center = view.center
        view.addSubview(cardView)
        cardView.delegate = self
        cardView.dataSource = self
        cardView.reloadData()
    }
    
}

extension DrawableCardViewController {
    @objc private func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            cardView.revokeCard()
        case 101:
            cardView.removeAll(animated: skipAnimateSwitch.isOn)
        case 102:
            sender.isHidden = true
            cardView.reloadData()
        default:
            break
        }
    }
    
    @objc func switchChangedAction(_ sender: UISwitch) {
        print(sender.tag)
        switch sender.tag {
        case 100:
            if cardView.isEmpty {
                reloadBtn.isHidden = true
                cardView.reloadData()
            }
            break
        case 101:
            cardView.isOverlap = sender.isOn
            cardView.removeAll(animated: false)
            reloadBtn.isHidden = true
            cardView.reloadData()
            break
        case 102:
            break
        default:
            break
        }
    }
    
}

// MARK: - CardViewDelegate
extension DrawableCardViewController: CardViewDelegate {
    
    func didClick(cardView: CardView, with index: Int) {
        print("click index: \(index)")
    }
    
    func revoke(cardView: CardView, item: CardItem, with index: Int) {
        print("revoke index: \(index)")
    }
    
    func remove(cardView: CardView, item: CardItem, with index: Int) {
        print("remove: \(index)")
        if index == count - 1 {
            if autoReloadSwitch.isOn {
                cardView.reloadData()
            } else {
                reloadBtn.isHidden = false
            }
        }
    }
}

// MARK: - CardViewDataSource
extension DrawableCardViewController: CardViewDataSource {
    
    func numberOfItems(in cardView: CardView) -> Int {
        return count
    }
    
    func cardView(_ cardView: CardView, cellForItemAt index: Int) -> CardItem {
        var item: ImageCardItem
        
        if let image = UIImage(named: "img_0" + "\(index)") {
            item = ImageCardItem(image: image)
        } else {
            item = ImageCardItem(image: UIImage.getImageWithColor(color: .randomColor()))
        }
        
        if index == count - 1 {
            addStartButton(item: item)
            item.isPan = false // 此属性可以让cardItem不能移动.
        }
        return item
    }
    
    
}

extension DrawableCardViewController {
    
    fileprivate func addStartButton(item: CardItem) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        button.setBackgroundImage(UIImage(named: "start_button"), for: .normal)
        button.addTarget(self, action: #selector(startAction(_:)), for: .touchUpInside)
        item.contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        item.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: item, attribute: .centerX, multiplier: 1, constant: 0))
        item.addConstraint(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: item, attribute: .bottom, multiplier: 1, constant: -30))
        startButton = button
    }
    
    @objc func startAction(_ button: UIButton) {
        print("start button clicked")
        cardView.removeTopItem(with: .up)
    }
}
