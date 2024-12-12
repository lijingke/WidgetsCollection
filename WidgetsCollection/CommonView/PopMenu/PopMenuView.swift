//
//  PopMenuView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import Foundation
import UIKit

// 代理方法，选中事件
protocol POPMenuViewDelegate {
    func POPMenuViewDidSelectedAt(index: Int)
}

enum PopMenueDirection {
    case left
    case right
}

class PopMenuView: UIView {
    // MARK: Property

    var delegate: POPMenuViewDelegate?
    var font: UIFont = .semibold(14)!
    var direction: PopMenueDirection = .left
    var menuArr: [PopMenu] = .init() {
        didSet {
            tableView.reloadData()
        }
    }

    var orign: CGPoint = .zero
    var cellHeight: CGFloat = 44
    // 分割线颜色
    var separtorColor: UIColor = .black
    var textColor: UIColor = kThemeColor
    // 背景颜色
    var bgColor: UIColor = .white {
        didSet {
            tableView.backgroundColor = bgColor
        }
    }

    var contentView: PopBubbleView!

    var contentFrame: CGRect = .zero

    // MARK: Life Cycle

    init(dataArray: [PopMenu], origin: CGPoint, size: CGSize, direction: PopMenueDirection) {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        self.direction = direction
        orign = origin
        cellHeight = size.height
        backgroundColor = UIColor(white: 0.3, alpha: 0.2)
        contentView = PopBubbleView(direction: direction, fillColor: .white)
        if direction == PopMenueDirection.left {
            contentView.frame = CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height * CGFloat(dataArray.count)+8)
        } else {
            contentView.frame = CGRect(x: origin.x, y: origin.y, width: -size.width, height: size.height * CGFloat(dataArray.count)+8)
        }
        contentFrame = contentView.frame
        InitUI()
        menuArr = dataArray
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        dismiss()
    }

    // MARK: Lazy Get

    lazy var tableView: UITableView = {
        let tabV = UITableView(frame: CGRect.zero, style: .plain)
        tabV.backgroundColor = UIColor.white
        tabV.bounces = false
        tabV.layer.cornerRadius = 5
        tabV.delegate = self
        tabV.dataSource = self
        tabV.register(PopMenuViewCell.self, forCellReuseIdentifier: "menuCell")
        return tabV
    }()
}

// MARK: - UI

extension PopMenuView {
    func InitUI() {
        addSubview(contentView)
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.bottom.right.equalToSuperview()
        }
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Event

extension PopMenuView {
    func pop() {
        guard let window = kWindow else { return }
        window.addSubview(self)
        contentView.frame = CGRect(x: orign.x, y: orign.y, width: 0, height: 0)
        UIView.animate(withDuration: 0.2) {
            self.contentView.frame = self.contentFrame
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.frame = CGRect(x: self.orign.x, y: self.orign.y, width: 0, height: 0)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PopMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return menuArr.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! PopMenuViewCell
        let menu = menuArr[indexPath.row]
        cell.setupData(menu)
        cell.titleLabel.font = font
        cell.titleLabel.textColor = textColor
        cell.separtorLine.isHidden = (indexPath.row < menuArr.count - 1) ? false : true
        cell.separtorLine.backgroundColor = separtorColor
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.POPMenuViewDidSelectedAt(index: indexPath.row)
    }
}
