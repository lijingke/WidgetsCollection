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
    
    var headViewTitles: [String] = []
    
    var dataSource: [[HomeDataEntity]] = []
    
    fileprivate func getDataSource() {
        
        headViewTitles = ["UI Components", "CollectionView Basics", "CUSTOM LAYOUT", "UIScrollView", "UIView Animations", "CALYER", "UIView Refresh", "Location", "NotificationCenter", "Download", "Safe"]
        var dicArray: [[CellInfoEnum : String]] = []
        
        for section in 0...headViewTitles.count {
            switch section {
            case 0:
                dicArray = [[.cellName : "Tabbar", .className : "MainTabbarController"], [.cellName : "DrawableCard", .className : "DrawableCardViewController"], [.cellName : "TisprCardStack", .className : "TisprCardStackViewController"], [.cellName : "UIPasteboard", .className : "UIPasteboardViewController"], [.cellName : "ImagePicker", .className : "ImagePickerViewController"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
                break
            case 1:
                dicArray = [[.cellName : "基础布局篇", .className : "BasicViewController", .pushType : "pop"], [.cellName : "布局和代理篇", .className : "LayoutAndDelegateViewController", .pushType : "pop"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
            case 2:
                dicArray = [[.cellName : "卡片布局", .className : "CardLayoutViewController", .pushType : "pop"], [.cellName : "瀑布流布局", .className : "WaterFallsViewController", .pushType : "pop"], [.cellName : "可伸缩Header", .className : "StretchyHeaderViewController", .pushType : "pop"], [.cellName : "标签布局", .className : "TagViewController"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
            case 3:
                dicArray = [[.cellName : "滚动视图", .className : "ScrollViewController"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
            case 4:
                dicArray = [[.cellName : "CGAffineTransform", .className : "CGAffineTransformViewController"], [.cellName : "UIView Animations - 01", .className : "AnimationsExamplesOneViewController"], [.cellName : "UIView Animations - 02", .className : "AnimationsExamplesTwoViewController"], [.cellName : "UIImageView Animations", .className : "ImageViewAnimationViewController"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
            case 5:
                dicArray = [[.cellName : "CALayer", .className : "CALayerViewController"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
            case 6:
                dicArray = [[.cellName : "SetNeedsLayout", .className : "UIViewRefreshViewController"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
            case 7:
                dicArray = [[.cellName : "Location", .className : "GetLocationViewController"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
            case 8:
                dicArray = [[.cellName : "NotificationCenterDemo", .className : "NotificationCenterViewController"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
            case 9:
                dicArray = [[.cellName : "PDF Download", .className : "PDFDownloadViewController"], [.cellName : "XMessage", .className : "ChatFilterViewController"]]
                let entities = dicArray.compactMap{HomeDataEntity($0)}
                dataSource.append(entities)
            case 10:
                dicArray = [[.cellName : "手势解锁", .className : "GestureUnlockViewController"]]
                
                let entities = dicArray.compactMap{HomeDataEntity($0)}
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
