//
//  PDFDownloadViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit
import Tiercel

class PDFDownloadViewController: UIViewController {
    
    //    var sessionManager = appDelegate.sessionManager
    fileprivate var sessionManager: SessionManager = {
        var configuration = SessionConfiguration()
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 10
        let manager = SessionManager("default", configuration: configuration, operationQueue: DispatchQueue(label: "com.Tiercel.SessionManager.operationQueue"))
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        creatData()
        addListener()
    }
    
    deinit {
        print("bye")
    }
    
    fileprivate func configureUI() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var mainView: PDFDownloadView = {
        let view = PDFDownloadView()
        view.delegate = self
        return view
    }()
}

// MARK: - Setup Data
extension PDFDownloadViewController {
    
    /// 检查文件是否已下载
    fileprivate func checkHasDownload(_ filePath: String) -> Bool {
        let task = self.sessionManager.fetchTask(filePath)
        let hasDownload = sessionManager.cache.fileExists(fileName: task?.fileName ?? "")
        return hasDownload
    }
    
    /// 创建数据源
    fileprivate func creatData() {
        var temArr = [PDFEntity]()
        for i in 0...7 {
            var entity = PDFEntity()
            switch i {
            case 0:
                entity.name = "淋病诊断"
                entity.indexInfo = "(WS 268—2019)"
                entity.cover = "cover_lb"
                entity.filePath = "http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.4.dmg"
            case 1:
                entity.name = "梅毒诊断"
                entity.indexInfo = "(WS 273—2018)"
                entity.cover = "cover_md"
                entity.filePath = "http://www.gov.cn/zhengce/pdfFile/2018_PDF.pdf"
            case 2:
                entity.name = "麻风病诊断"
                entity.indexInfo = "(WS 291-2018)"
                entity.cover = "cover_mfb"
                entity.filePath = "http://www.gov.cn/zhengce/pdfFile/2017_PDF.pdf"
            case 3:
                entity.name = "软下疳诊断"
                entity.indexInfo = "(WS_T 191-2017)"
                entity.cover = "cover_rxg"
                entity.filePath = "http://www.gov.cn/zhengce/pdfFile/2016_PDF.pdf"
            case 4:
                entity.name = "生殖器疱疹诊断"
                entity.indexInfo = "(WS_T 236-2017)"
                entity.cover = "cover_szqpz"
                entity.filePath = "http://www.gov.cn/zhengce/pdfFile/2015_PDF.pdf"
            case 5:
                entity.name = "尖锐湿疣诊断"
                entity.indexInfo = "(WST 235-2016)"
                entity.cover = "cover_jrsy"
                entity.filePath = "http://www.gov.cn/zhengce/pdfFile/2014_PDF.pdf"
            case 6:
                entity.name = "生殖道沙眼衣原体感染诊断"
                entity.indexInfo = "(WS_T 513-2016)"
                entity.cover = "cover_szdsyyyt"
                entity.filePath = "http://www.gov.cn/zhengce/pdfFile/2013_PDF.pdf"
            case 7:
                entity.name = "性病性淋巴肉芽肿诊断"
                entity.indexInfo = "(WS_T 237-2016)"
                entity.cover = "cover_venereum"
                entity.filePath = "http://www.gov.cn/zhengce/pdfFile/2012_PDF.pdf"
            default:
                break
            }
            
            temArr.append(entity)
        }
        
        let dataSource = temArr.compactMap { (element) -> PDFEntity in
            var entity: PDFEntity = element
            entity.hasDownload = checkHasDownload(entity.filePath ?? "")
            return entity
        }
        
        let groupData = dataSource.clump(by: 3)
        mainView.setupData(groupData)
    }
    
}

// MARK: - PDFDownloadDelegate
extension PDFDownloadViewController: PDFDownloadDelegate {
    func downloadCellDidClicked(_ cell: PDFCollectionCell) {
        let data = cell.entity
        let filePath = data?.filePath ?? ""
        let task = sessionManager.fetchTask(filePath)
        if data?.hasDownload == true {
            let vc = PDFPreviewViewController()
            vc.mainView.filePath = task?.filePath
            vc.mainView.headInfoView.pdfInfo = data
            navigationController?.pushViewController(vc, animated: true)
        }else {
            
            let downloadTask = sessionManager.download(data?.filePath ?? "")
            
            downloadTask?.progress(onMainQueue: true, handler: { (task) in
                let progress = task.progress.fractionCompleted
                print("下载中，进度：\(progress)")
                cell.setProgress(progress: Float(progress))
            }).completion(handler: { [weak self] (task) in
                if task.status == .succeeded {
                    // 下载成功
                    let result = self?.checkHasDownload(cell.entity?.filePath ?? "")
                    cell.entity?.hasDownload = result
                    print("下载完成")
                } else {
                    print("下载失败")
                    // 其他状态
                }
            })
            
        }
        
    }
    
}

extension PDFDownloadViewController {
    fileprivate func addListener() {
        NotificationCenter.default.addObserver(forName: DownloadTask.didCompleteNotification, object: nil, queue: nil) { (notification) in
            guard let task = notification.downloadTask else { return }
            print(task.status)
        }
    }
}
