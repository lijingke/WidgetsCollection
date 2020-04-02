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
    }
    
    fileprivate func configureNav() {
        navigationItem.title = "WidgetsCollection"
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    let headViewTitles = ["BASICS", "CUSTOM LAYOUT", "UIScrollView", "UIView Animations", "CALYER", "UIView Refresh", "Location", "NotificationCenter", "Download"]
    
    let dataSource: [[String]] = [["基础布局篇", "布局和代理篇"], ["卡片布局", "瀑布流布局", "可伸缩Header", "标签布局"], ["滚动视图"], ["CGAffineTransform", "UIView Animations - 01", "UIView Animations - 02", "UIImageView Animations"], ["CALayer"], ["SetNeedsLayout"], ["Location"], ["NotificationCenterDemo"], ["PDF Download", "XMessage"]]
    
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
        
        let title = dataSource[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let vc = BasicViewController()
                DispatchQueue.main.async {[weak self] in
                    self?.present(vc, animated: true, completion: nil)
                }
            case 1:
                let vc = LayoutAndDelegateViewController()
                DispatchQueue.main.async {[weak self] in
                    self?.present(vc, animated: true, completion: nil)
                }
            default:
                break
            }
            
        }else if indexPath.section == 1 {
            
            switch indexPath.row {
            case 0:
                let vc = CardLayoutViewController()
                DispatchQueue.main.async {[weak self] in
                    self?.present(vc, animated: true, completion: nil)
                }
            case 1:
                let vc = WaterFallsViewController()
                DispatchQueue.main.async {[weak self] in
                    self?.present(vc, animated: true, completion: nil)
                }
            case 2:
                let vc = StretchyHeaderViewController()
                DispatchQueue.main.async {[weak self] in
                    self?.present(vc, animated: true, completion: nil)
                }
            case 3:
                
                let vc = TagViewController()
                vc.navigationItem.title = title
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                let vc = ScrollViewController()
                vc.navigationItem.title = "ScrollView"
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                let vc = CGAffineTransformViewController()
                vc.navigationItem.title = "CGAffineTransform"
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = AnimationsExamplesOneViewController()
                vc.title = title
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = AnimationsExamplesTwoViewController()
                vc.title = title
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = ImageViewAnimationViewController()
                vc.title = title
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
            
        }else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                let vc = CALayerViewController()
                vc.title = title
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
            
        }else if indexPath.section == 5 {
            switch indexPath.row {
            case 0:
                let vc = UIViewRefreshViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }else if indexPath.section == 6 {
            switch indexPath.row {
            case 0:
                let vc = GetLocationViewController()
                vc.navigationItem.title = "GetLocationDemo"
                navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        }else if indexPath.section == 7 {
            switch indexPath.row {
            case 0:
                let vc = NotificationCenterViewController()
                vc.navigationItem.title = "NotificationCenterDemo"
                navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        }else if indexPath.section == 8 {
            switch indexPath.row {
            case 0:
                let vc = PDFDownloadViewController()
                vc.navigationItem.title = "PDF Download"
                navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = ChatFilterViewController()
                vc.navigationItem.title = "筛选"
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
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
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        return cell
    }
    
}
