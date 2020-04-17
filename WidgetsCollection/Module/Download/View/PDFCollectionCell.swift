//
//  PDFCollectionCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/5.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class PDFCollectionCell: UICollectionViewCell {
    
    static let reuseId = "PDFCollectionCell"
    var tapBlock: (()->())?
    var entity: PDFEntity? {
        didSet {
            configureData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapAction() {
        if entity?.hasDownload == false {
            downView.isHidden = false
        }
        
        tapBlock?()
    }
    
    public func setProgress(progress: Float) {
        downView.progressView.progress = progress
    }
    
    fileprivate func configureUI() {
        addSubview(coverImg)
        addSubview(pdfName)
        addSubview(indexLabel)
        addSubview(readIcon)
        addSubview(readNum)
        coverImg.addSubview(downloadedIcon)
        coverImg.addSubview(downView)
        
        coverImg.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        pdfName.snp.makeConstraints { (make) in
            make.top.equalTo(coverImg.snp.bottom).offset(5)
            make.left.right.equalTo(coverImg)
        }
        
        indexLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pdfName.snp.bottom)
            make.left.equalTo(pdfName)
        }
        
        readIcon.snp.makeConstraints { (make) in
            make.top.equalTo(indexLabel.snp.bottom).offset(8)
            make.left.equalTo(indexLabel)
        }
        
        readNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(readIcon)
            make.left.equalTo(readIcon.snp.right).offset(2)
        }
        
        downloadedIcon.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5.5)
            make.left.equalToSuperview().offset(6.5)
            make.size.equalTo(CGSize(width: 12.5, height: 12.5))
        }
        
        downView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public func configureData() {
        coverImg.image = UIImage(named: entity?.cover ?? "")
        pdfName.text = entity?.name
        indexLabel.text = entity?.indexInfo
        readNum.text = entity?.readNum
        downloadedIcon.isHidden = !(entity?.hasDownload ?? false)
        downView.isHidden = true
    }
    
    lazy var coverImg: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "cover_jrsy")
        return view
    }()
    
    lazy var pdfName: UILabel = {
        let label = UILabel()
        label.text = "淋病诊断"
        label.font = UIFont.medium(14)
        label.textColor = UIColor(hex: 0x333333)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.text = "(WS 268-2019)"
        label.font = UIFont.medium(10)
        label.textColor = UIColor(hex: 0x151515)
        return label
    }()
    
    lazy var readIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_read")
        return view
    }()
    
    lazy var readNum: UILabel = {
        let label = UILabel()
        label.text = "3.25万"
        label.font = UIFont.regular(12)
        label.textColor = UIColor(hex: 0x7E7E7E)
        return label
    }()
    
    lazy var downView: downloadView = {
        let view = downloadView()
        view.isHidden = true
        return view
    }()
    
    lazy var downloadedIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_download")
        view.isHidden = true
        return view
    }()
}

class downloadView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureUI() {
        self.backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)
        addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(9.5)
            make.right.equalToSuperview().offset(-9.5)
            make.bottom.equalToSuperview().offset(-11)
        }
    }
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressViewStyle = .default
        view.backgroundColor = UIColor(hex: 0xE9E9E9)
        view.progressTintColor = UIColor(hex: 0x4571E6)
        view.progress = 0
        return view
    }()
}
