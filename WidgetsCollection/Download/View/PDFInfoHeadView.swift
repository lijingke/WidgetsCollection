//
//  PDFInfoHeadView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/12/6.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class PDFInfoHeadView: UIView {
    
    public var pdfInfo: PDFEntity? {
        didSet {
            configureData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureUI() {
        backgroundColor = .white
        addSubview(pdfName)
        addSubview(indexLabel)
        addSubview(readNum)
        
        pdfName.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        indexLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pdfName.snp.bottom)
            make.left.equalTo(pdfName)
        }
        
        readNum.snp.makeConstraints { (make) in
            make.top.equalTo(indexLabel.snp.bottom).offset(8)
            make.left.equalTo(indexLabel)
        }
    }
    
    fileprivate func configureData() {
        pdfName.text = pdfInfo?.name
        indexLabel.text = pdfInfo?.indexInfo
        readNum.text = (pdfInfo?.readNum ?? "\(0)") + "人次阅读"
    }
    
    lazy var pdfName: UILabel = {
        let label = UILabel()
        label.text = "淋病诊断"
        label.font = UIFont.semibold(22)
        label.textColor = UIColor(hex: 0x333333)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.text = "(WS 268-2019)"
        label.font = UIFont.semibold(18)
        label.textColor = UIColor(hex: 0x151515)
        return label
    }()
    
    lazy var readNum: UILabel = {
        let label = UILabel()
        label.text = "3.25万人次阅读"
        label.font = UIFont.regular(14)
        label.textColor = UIColor(hex: 0x999999)
        return label
    }()

}
