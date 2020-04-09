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
    }
    
    fileprivate func setupUI() {
        view.addSubview(autoReloadSwitch)
        autoReloadSwitch.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func switchChangedAction(_ sender: UISwitch) {
        print(sender.tag)
    }
        
    lazy var autoReloadSwitch: UISwitch = {
        let view = UISwitch()
        view.isOn = true
        view.addTarget(self, action: #selector(self.switchChangedAction(_:)), for: .touchUpInside)
        return view
    }()
    
//    lazy var skipAnimateSwitch: UISwitch = {
//        let view = UISwitch()
//        view.addTarget(self, action: #selector(self.switchChangedAction(_:)), for: .valueChanged)
//        return view
//    }()
    
//    lazy var reloadSwitch: UISwitch = {
//        let view = UISwitch()
//        view.addTarget(self, action: #selector(self.switchChangedAction(_:)), for: .valueChanged)
//        return view
//    }()
    
    fileprivate func addCardView() {
        cardView = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        cardView.center = view.center
        view.addSubview(cardView)
        cardView.delegate = self
        cardView.dataSource = self
        cardView.reloadData()
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
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.addTarget(self, action: #selector(startAction(_:)), for: .touchUpInside)
        item.contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        item.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: item, attribute: .centerX, multiplier: 1, constant: 0))
        item.addConstraint(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: item, attribute: .bottom, multiplier: 1, constant: -30))
        
        startButton = button
    }
    
    @objc func startAction(_ button: UIButton) {
        print("start button clicked")
        cardView.removeTopItem(with: .up)
    }
}
