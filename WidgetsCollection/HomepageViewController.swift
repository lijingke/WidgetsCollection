//
//  HomepageViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/2.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit
import SnapKit

class HomepageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNav()
        configureUI()
        getDataSource()
    }
    
    fileprivate func configureNav() {
        navigationItem.title = "WidgetsCollection"
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    let headViewTitles = ["BASICS", "CUSTOM LAYOUT", "UIScrollView", "UIView Animations", "CALYER", "UIView Refresh", "Location", "NotificationCenter", "Download", "Safe"]
    
    //    let dataSource: [[String]] = [["基础布局篇", "布局和代理篇"], ["卡片布局", "瀑布流布局", "可伸缩Header", "标签布局"], ["滚动视图"], ["CGAffineTransform", "UIView Animations - 01", "UIView Animations - 02", "UIImageView Animations"], ["CALayer"], ["SetNeedsLayout"], ["Location"], ["NotificationCenterDemo"], ["PDF Download", "XMessage"], ["手势解锁"]]
    var dataSource: [[HomeDataEntity]] = []
    
    
    fileprivate func getDataSource() {
        
        for section in 0...headViewTitles.count {
            switch section {
            case 0:
                let dictionary: [[Int : String]] = [[0 : "基础布局篇", 1 : "BasicViewController", 2 : "pop"], [0 : "布局和代理篇", 1 : "LayoutAndDelegateViewController", 2 : "pop"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    entity.pushType = dic[2]
                    return entity
                }
                dataSource.append(entities)
            case 1:
                let dictionary: [[Int : String]] = [[0 : "卡片布局", 1 : "CardLayoutViewController", 2 : "pop"], [0 : "瀑布流布局", 1 : "WaterFallsViewController", 2 : "pop"], [0 : "可伸缩Header", 1 : "StretchyHeaderViewController", 2 : "pop"], [0 : "标签布局", 1 : "TagViewController"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    entity.pushType = dic[2]
                    return entity
                }
                dataSource.append(entities)
            case 2:
                let dictionary: [[Int : String]] = [[0 : "滚动视图", 1 : "ScrollViewController"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    return entity
                }
                dataSource.append(entities)
            case 3:
                let dictionary: [[Int : String]] = [[0 : "CGAffineTransform", 1 : "CGAffineTransformViewController"], [0 : "UIView Animations - 01", 1 : "AnimationsExamplesOneViewController"], [0 : "UIView Animations - 02", 1 : "AnimationsExamplesTwoViewController"], [0 : "UIImageView Animations", 1 : "ImageViewAnimationViewController"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    return entity
                }
                dataSource.append(entities)
            case 4:
                let dictionary: [[Int : String]] = [[0 : "CALayer", 1 : "CALayerViewController"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    return entity
                }
                dataSource.append(entities)
            case 5:
                let dictionary: [[Int : String]] = [[0 : "SetNeedsLayout", 1 : "UIViewRefreshViewController"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    return entity
                }
                dataSource.append(entities)
            case 6:
                let dictionary: [[Int : String]] = [[0 : "Location", 1 : "GetLocationViewController"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    return entity
                }
                dataSource.append(entities)
            case 7:
                let dictionary: [[Int : String]] = [[0 : "NotificationCenterDemo", 1 : "NotificationCenterViewController"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    return entity
                }
                dataSource.append(entities)
            case 8:
                let dictionary: [[Int : String]] = [[0 : "PDF Download", 1 : "PDFDownloadViewController"], [0 : "XMessage", 1 : "ChatFilterViewController"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    return entity
                }
                dataSource.append(entities)
            case 9:
                let dictionary: [[Int : String]] = [[0 : "手势解锁", 1 : "GestureUnlockViewController"]]
                let entities = dictionary.compactMap { (dic) -> HomeDataEntity? in
                    var entity = HomeDataEntity()
                    entity.cellName = dic[0]
                    entity.className = dic[1]
                    return entity
                }
                dataSource.append(entities)
            default:
                break
            }
        }
        tableView.reloadData()
    }
    
    fileprivate func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
}

extension HomepageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = UITableViewHeaderFooterView()
        head.textLabel?.text = headViewTitles[section]
        return head
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entity = dataSource[indexPath.section][indexPath.row]
        let className = entity.className ?? ""
        if entity.pushType == "pop" {
            if let vc = self.getVCFromString(className) {
                DispatchQueue.main.async {[weak self] in
                    self?.present(vc, animated: true, completion: nil)
                }
            }
        }else {
            if let vc = self.getVCFromString(className) {
                vc.navigationItem.title = entity.cellName
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension HomepageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row].cellName
        return cell
    }
    
}
