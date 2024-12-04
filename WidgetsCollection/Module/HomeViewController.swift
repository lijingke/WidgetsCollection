//
//  HomeViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/2.
//  Copyright © 2020 李京珂. All rights reserved.
//

import SnapKit
import UIKit

class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        MBProgressManager.showLoadingOrdinary("Loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            MBProgressManager.showHUD(withSuccess: "加载成功")
        }

        configureNav()
        configureUI()
        getDataSource()
    }

    fileprivate func configureNav() {
        navigationItem.title = "瓦西里的百宝箱"
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }

    var headViewTitles: [String] = []

    var dataSource: [[HomeDataEntity]] = []

    fileprivate func getDataSource() {
        headViewTitles = ["WorkSpace", "Sound&Vibrate", "Picker", "TableView", "Core Animation", "Playgrounds", "UI Components", "Toolbox", "CollectionView Basics", "CollectionView Custom Layout", "UIScrollView", "UIView Animations", "CALYER", "UIView Refresh", "Location", "NotificationCenter", "Download", "Safe", "Health Kit"]

        for title in headViewTitles {
            var dicArray: [[CellInfoEnum: Any]] = []
            switch title {
            case "WorkSpace":
                dicArray = [
                    [.cellName: "RPlus", .className: "ProcessProgressVC"],
                    [.cellName: "富文本点击", .className: "AttributedStringViewController"],
                ]
            case "Sound&Vibrate":
                dicArray = [
                    [.cellName: "Sound", .className: "SoundListViewController"],
                    [.cellName: "Vibrate", .className: "VibrateListViewController"]
                ]
            case "Picker":
                dicArray = [
                    [.cellName: "Picker", .className: "PIViewController", .pushType: PushType.nib],
                ]
            case "TableView":
                dicArray = [
                    [.cellName: "StretchyHeader", .className: "StretchyHeaderTableViewVC"],
                ]
            case "Core Animation":
                dicArray = [
                    [.cellName: "Finish Animation", .className: "FinishAnimationViewController"],
                ]
            case "Playgrounds":
                dicArray = [
                    [.cellName: "UIViewTestVC", .className: "UIViewTestVC"],
                    [.cellName: "刷新", .className: "RefreshViewController"],
                    [.cellName: "Combine", .className: "ViewController"],
                ]
            case "UI Components":
                dicArray = [
                    [.cellName: "ExpandableLabel", .className: "ExpandableLabelVC", .pushType: PushType.nib],
                    [.cellName: "Tabbar", .className: "TabbarController"],
                    [.cellName: "DrawableCard", .className: "DrawableCardViewController"],
                    [.cellName: "TisprCardStack", .className: "TisprCardStackViewController"],
                    [.cellName: "UIPasteboard", .className: "UIPasteboardViewController"],
                    [.cellName: "ImagePicker", .className: "ImagePickerViewController"],
                    [.cellName: "HUD Test", .className: "HUDManagerDemoViewController"],
                ]
            case "Toolbox":
                dicArray = [
                    [.cellName: "App Search", .className: "AppSearchViewController"],
                    [.cellName: "周会幸运星", .className: "LotteryViewController"],
                ]
            case "CollectionView Basics":
                dicArray = [
                    [.cellName: "基础布局篇", .className: "BasicViewController", .pushType: PushType.present],
                    [.cellName: "布局和代理篇", .className: "LayoutAndDelegateViewController", .pushType: PushType.present],
                ]
            case "CollectionView Custom Layout":
                dicArray = [
                    [.cellName: "卡片布局", .className: "CardLayoutViewController", .pushType: PushType.present],
                    [.cellName: "瀑布流布局", .className: "WaterFallsViewController", .pushType: PushType.present],
                    [.cellName: "可伸缩Header", .className: "StretchyHeaderViewController", .pushType: PushType.present],
                    [.cellName: "标签布局", .className: "TagViewController"],
                ]
            case "UIScrollView":
                dicArray = [
                    [.cellName: "滚动视图", .className: "ScrollViewController"],
                ]
            case "UIView Animations":
                dicArray = [
                    [.cellName: "CGAffineTransform", .className: "CGAffineTransformViewController"],
                    [.cellName: "UIView Animations - 01", .className: "AnimationsExamplesOneViewController"],
                    [.cellName: "UIView Animations - 02", .className: "AnimationsExamplesTwoViewController"],
                    [.cellName: "UIImageView Animations", .className: "ImageViewAnimationViewController"],
                ]
            case "CALYER":
                dicArray = [
                    [.cellName: "CALayer", .className: "CALayerViewController"],
                ]
            case "UIView Refresh":
                dicArray = [
                    [.cellName: "SetNeedsLayout", .className: "UIViewRefreshViewController"],
                ]
            case "Location":
                dicArray = [
                    [.cellName: "Location", .className: "GetLocationViewController"],
                ]
            case "NotificationCenter":
                dicArray = [
                    [.cellName: "NotificationCenterDemo", .className: "NotificationCenterViewController"],
                ]
            case "Download":
                dicArray = [
                    [.cellName: "PDF Download", .className: "PDFDownloadViewController"],
                    [.cellName: "XMessage", .className: "ChatFilterViewController"],
                ]
            case "Safe":
                dicArray = [
                    [.cellName: "手势解锁", .className: "GestureUnlockViewController"],
                ]
            case "Health Kit":
                dicArray = [
                    [.cellName: "Electrocardiograms (ECG)", .className: "ECGMeasureListVC"],
                ]
            default:
                break
            }
            let entities = dicArray.compactMap { HomeDataEntity($0) }
            if entities.count > 0 {
                dataSource.append(entities)
            }
        }

        tableView.reloadData()
    }

    fileprivate func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        return table
    }()
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = UITableViewHeaderFooterView()
        head.textLabel?.text = headViewTitles[section]
        return head
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let entity = dataSource[indexPath.section][indexPath.row]
        let className = entity.className ?? ""
        switch entity.pushType {
        case .navi:
            if let vc = getVCFromString(className) {
                vc.navigationItem.title = entity.cellName
                navigationController?.pushViewController(vc, animated: true)
            }
        case .present:
            if let vc = getVCFromString(className) {
                DispatchQueue.main.async { [weak self] in
                    self?.present(vc, animated: true, completion: nil)
                }
            }
        case .nib:
            if let vc = getVCClassFromString(className) {
                navigationController?.pushViewController(vc.loadFromNib(), animated: true)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row].cellName
        return cell
    }
}
