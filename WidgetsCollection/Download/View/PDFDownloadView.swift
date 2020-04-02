//
//  PDFDownloadView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class PDFDownloadView: UIView {
    
//    var sessionManager = appDelegate.sessionManager
    var sessionManager: SessionManager = {
        var configuration = SessionConfiguration()
        configuration.allowsCellularAccess = true
        let manager = SessionManager("default", configuration: configuration, operationQueue: DispatchQueue(label: "com.Tiercel.SessionManager.operationQueue"))
        return manager
    }()

    
    var dataSource: [[PDFEntity]] = [[PDFEntity]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        createData()
    }
    
    deinit {
        print("leave")
    }
    
    fileprivate func configureUI() {
        self.backgroundColor = .white
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let itemWidth = (UIScreen.main.bounds.width - 30 * 4) / 3
        let itemHeight = itemWidth * 1.5728
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight + 70)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        layout.footerReferenceSize = CGSize(width: self.bounds.width, height: 5)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor(hex: 0xF5F8FA)
        collection.dataSource = self
        collection.delegate = self
        collection.register(PDFCollectionCell.self, forCellWithReuseIdentifier: PDFCollectionCell.reuseId)
        collection.register(PDFCollectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PDFCollectionFooter.reuseID)
        return collection
    }()
}

extension PDFDownloadView: UICollectionViewDelegate {
    
}

extension PDFDownloadView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PDFCollectionCell.reuseId, for: indexPath) as? PDFCollectionCell else {
            return UICollectionViewCell()
        }
        let pdfEntity = dataSource[indexPath.section][indexPath.row]
        let filePath = pdfEntity.filePath ?? ""
        let task = self.sessionManager.fetchTask(filePath)
        let hasDownload = sessionManager.cache.fileExists(fileName: task?.fileName ?? "")
        dataSource[indexPath.section][indexPath.row].hasDownload = hasDownload
        cell.entity = dataSource[indexPath.section][indexPath.row]
        cell.tapBlock = {[weak self] () in
            if cell.entity?.hasDownload == true {
                let controller = self?.getFirstViewController()
                let vc = PDFPreviewViewController()
                vc.mainView.filePath = task?.filePath
                vc.mainView.headInfoView.pdfInfo = pdfEntity
                controller?.navigationController?.pushViewController(vc, animated: true)
            }else {
                let task = self?.sessionManager.download(cell.entity?.filePath ?? "")
                
                task?.progress(onMainQueue: true, { (task) in
                    let progress = task.progress.fractionCompleted
                    print("下载中，进度：\(progress)")
                    cell.setProgress(progress: Float(progress))
                }).success({ (task) in
                    self?.collectionView.reloadData()
                    print("下载完成")
                }).failure({ (task) in
                    print("下载失败")
                })
            }
            
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PDFCollectionFooter.reuseID, for: indexPath) as! PDFCollectionFooter
            return view
        default:
            fatalError("No Such Kind")
        }
    }
    
    func createData() {
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
        dataSource = temArr.clump(by: 3)
    }
    
}
