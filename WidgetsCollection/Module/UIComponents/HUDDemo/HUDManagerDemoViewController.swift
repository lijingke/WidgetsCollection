//
//  HUDManagerDemoViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/28.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation

class HUDManagerDemoViewController: UIViewController {
    
    private var cellData: [String] = []
    private var progressValue: CGFloat = 0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getData()
        setupUI()
    }
    
    deinit {
        print("byebye")
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
    //        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        return table
    }()
    
    private func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(changeProgressValue), userInfo: nil, repeats: true)
    }
    
    @objc func changeProgressValue() {
        progressValue += 0.1
        print(progressValue)
        MBProgressManager.uploadProgressOrdinary(progressValue)
        if Int(progressValue) == 1 {
            MBProgressManager.showHUD(withSuccess: "成功提示")
            timer?.invalidate()
            timer = nil
            progressValue = 0
        }
    }
}

extension HUDManagerDemoViewController {
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func getData() {
        cellData = ["普通菊花等待（完成自动消失）", "普通文字显示（完成自动消失）", "错误提示", "警告提示", "文字提示", "自定义图片", "动态图", "环形进度条1", "环形进度条2", "条形进度条"]
    }
    
    private func dismissHUD(withIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                MBProgressManager.showHUD(withSuccess: "成功提示")
            }
        case 1:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                MBProgressManager.showHUD(withSuccess: "成功提示")
            }
        case 5:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                MBProgressManager.showHUD(withSuccess: "成功提示")
            }
        case 6:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                MBProgressManager.showHUD(withSuccess: "成功提示")
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate
extension HUDManagerDemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            MBProgressManager.showLoadingOrdinary("显示中")
            break
        case 1:
            MBProgressManager.showHUDCustom { (make) in
                make.hudMode(.text).message("纯文字显示")
            }
        case 2:
            MBProgressManager.showHUD(withError: "错误提示")
        case 3:
            MBProgressManager.showHUD(withWarning: "警告提示")
        case 4:
            MBProgressManager.showHUD(withText: "文字提示")
        case 5:
            MBProgressManager.showHUDCustom { (make) in
                make.hudMode(.customView).imageStr("主页_我的").message("自定义图片")
            }
        case 6:
            let imageArray = [
                UIImage(named: "11"),
                UIImage(named: "22"),
                UIImage(named: "33"),
                UIImage(named: "44"),
                UIImage(named: "55"),
                UIImage(named: "66"),
                UIImage(named: "77")
            ]
            MBProgressManager.showHUDCustom { (make) in
                make.hudMode(.customView).animationDuration(0.4).imageArray(imageArray).message("动态图片")
            }
        case 7:
            MBProgressManager.showHUDCustom { (make) in
                make.hudMode(.annularDeterminate).message("环形进度条1")
            }
            initTimer()
            self.timer?.fire()
        case 8:
            MBProgressManager.showHUDCustom { (make) in
                make.hudMode(.determinate).message("环形进度条2")
            }
            initTimer()
            self.timer?.fire()
        case 9:
            MBProgressManager.showHUDCustom { (make) in
                make.hudMode(.determinateHorizontalBar).message("条形进度条")
            }
            initTimer()
            self.timer?.fire()
        default:
            break
        }
        self.dismissHUD(withIndexPath: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension HUDManagerDemoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = cellData[indexPath.row]
        return cell
    }
    
    
}
