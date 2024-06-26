//
//  UploadImageCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/22.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Photos
import UIKit

class UploadImageCell: UICollectionViewCell {
    public var asset: PHAsset? {
        didSet {
            videoImageView.isHidden = asset?.mediaType != PHAssetMediaType.video
            let filename = asset?.value(forKey: "filename") as! String
            let isGIF = filename.contains("GIF")
            gifLabel.isHidden = !isGIF
        }
    }

    public var row: Int? {
        didSet {
            deleteBtn.tag = row ?? 0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        gifLabel.frame = CGRect(x: width - 25, y: height - 14, width: 25, height: 14)
        deleteBtn.frame = CGRect(x: width - 36, y: 0, width: 36, height: 36)
        let width = self.width / 3
        videoImageView.frame = CGRect(x: width, y: width, width: width, height: width)
    }

    // MARK: - Lazy Get

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()

    lazy var videoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.tz_imageNamed(fromMyBundle: "MMVideoPreviewPlay")
        view.contentMode = .scaleAspectFill
        view.isHidden = true
        return view
    }()

    lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Photo_delete"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: -10)
        btn.alpha = 0.6
        return btn
    }()

    lazy var gifLabel: UILabel = {
        let label = UILabel()
        label.text = "GIF"
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
}

extension UploadImageCell {
    private func setupUI() {
        backgroundColor = .white
        addSubview(imageView)
        addSubview(videoImageView)
        addSubview(deleteBtn)
        addSubview(gifLabel)
    }

    @objc func getSnapShotView() -> UIView {
        let view = UIView()
        var cellSnapShotView: UIView?
        if responds(to: #selector(UIScreen.snapshotView(afterScreenUpdates:))) {
            cellSnapShotView = self.snapshotView(afterScreenUpdates: false)
        } else {
            let size = CGSize(width: width + 20, height: height + 20)
            UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0)
            if let context = UIGraphicsGetCurrentContext() {
                layer.render(in: context)
            }
            let cellSnapShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cellSnapShotView = UIImageView(image: cellSnapShotImage)
        }
        view.frame = CGRect(x: 0, y: 0, width: cellSnapShotView?.frame.size.width ?? 0, height: cellSnapShotView?.frame.size.height ?? 0)
        cellSnapShotView?.frame = CGRect(x: 0, y: 0, width: cellSnapShotView?.frame.size.width ?? 0, height: cellSnapShotView?.frame.size.height ?? 0)
        view.addSubview(cellSnapShotView ?? UIView())
        return view
    }
}
