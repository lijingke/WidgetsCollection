//
//  ImagePickerView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/16.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit
import Photos
import TZImagePickerController
import MobileCoreServices
import SDWebImage
import MBProgressHUD

protocol ImagePickerViewDelegate: NSObjectProtocol {
    func didClickSettingBtn()
}

class ImagePickerView: UIView {
    
    // MARK: Property
    weak var delegate:ImagePickerViewDelegate?
    /// 从相册中选择的图片
    public var selectedPhotos: [UIImage] = []
    /// 从相册中选择的图片PHAsset
    public var selectedAssets: [PHAsset] = []
    /// 从SM.MS图床下载的数据
    public var hasUploadData: [UploadHistoryModel?] = [] {
        didSet {
            if hasUploadData.count > 0 {
                headSize = CGSize(width: width, height: 50)
            } else {
                headSize = CGSize(width: width, height: 0)
            }
            layoutSubviews()
        }
    }
    /// 是否选择的原图
    private var isSelectedOringinalPhoto: Bool = false
    /// CollectionViewCell尺寸
    private var itemWH: CGFloat!
    /// CollectionViewCell边距
    private var margin: CGFloat!
    /// CollectionView的列数
    private var numberOfColumns: CGFloat!
    /// 定位信息
    private var location: CLLocation!
    /// 图片选择后上传操作队列
    private var operationQueue: OperationQueue?
    /// CollectionViewHead尺寸
    private var headSize: CGSize = CGSize(width: 0, height: 0)
    /// 选择图片的配置信息
    private var chooseConf = ImageChooseConf()
    /// 选择图片的配置菜单
    public var confScrollView: ConfigureView!
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        //        let contentSizeH = 14 * 35 + 20
        //        DispatchQueue.main.asyncAfter(deadline: .now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
        //
        //        }
        //
        
        let layout = collectionView.collectionViewLayout as! LxGridViewFlowLayout
        
        self.margin = 4
        self.numberOfColumns = 4
        
        let space = self.width - (numberOfColumns + 1) * margin
        self.itemWH =  space / numberOfColumns
        
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.headerReferenceSize = headSize
    }
        
    // MARK: Lazy Get
    lazy var collectionView: UICollectionView = {
        let layout = LxGridViewFlowLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.alwaysBounceVertical = true
        view.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        view.backgroundColor = .white
        view.delegate = self
        view.dataSource = self
        view.keyboardDismissMode = .onDrag
        view.register(TZTestCell.self, forCellWithReuseIdentifier: "TZTestCell")
        view.register(WebImageCollectionViewCell.self, forCellWithReuseIdentifier: WebImageCollectionViewCell.reuseId)
        view.register(collectionHead.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionHead.reuseID)
        return view
    }()
    
    lazy var imagePickerVC: UIImagePickerController = {
        let vc = UIImagePickerController()
        return vc
    }()
    
    lazy var configureView: UIView = {
        let view = UIView()
        let subView = Bundle(for: ConfigureView.self).loadNibNamed("ConfigureView", owner: nil, options: nil)?.first as! ConfigureView
        subView.eventDelegate = self
        subView.backgroundColor = .cyan
        view.addSubview(subView)
        subView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        self.confScrollView = subView
        self.chooseConf.showTakePhotoBtn = subView.showSheetSwitch.isOn
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        view.backgroundColor = UIColor.init(displayP3Red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        return view
    }()
    
    
}

// MARK: - Setup Data && UI
extension ImagePickerView {
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    public func setupData(_ models: [UploadHistoryModel?]) {
        self.hasUploadData = models
        collectionView.reloadData()
    }
    
}

// MARK: - TapAction
extension ImagePickerView {
    @objc func tapAction() {
        configureView.removeFromSuperview()
    }
}

// MARK: - UICollectionViewDelegate
extension ImagePickerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            return
        }
        
        if indexPath.item == selectedPhotos.count {
            if chooseConf.showSheet {
                var takePhotoTitle = "拍照"
                if chooseConf.showTakeVideoBtn && chooseConf.showTakePhotoBtn {
                    takePhotoTitle = "相机"
                } else if chooseConf.showTakeVideoBtn {
                    takePhotoTitle = "拍摄"
                }
                
                let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let takePhotoAction = UIAlertAction(title: takePhotoTitle, style: .default) { (action) in
                    self.takePhoto()
                }
                alertVC.addAction(takePhotoAction)
                let imagePickerAction = UIAlertAction(title: "去相册选择", style: .default) { (action) in
                    self.pushTZImagePickerController()
                }
                alertVC.addAction(imagePickerAction)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alertVC.addAction(cancelAction)
                
                let popover = alertVC.popoverPresentationController
                let cell = collectionView.cellForItem(at: indexPath)
                if popover != nil {
                    popover?.sourceView = cell
                    popover?.sourceRect = cell?.bounds ?? CGRect.zero
                    popover?.permittedArrowDirections = .any
                }
                let vc = self.getViewController()
                vc.present(alertVC, animated: true, completion: nil)
            } else {
                self.pushTZImagePickerController()
            }
        } else { // preview photos or video
            let asset = selectedAssets[indexPath.item]
            var isVideo = false
            isVideo = asset.mediaType == PHAssetMediaType.video
            let filename = asset.value(forKey: "filename") as? String ?? ""
            
            if filename.contains("GIF") && chooseConf.allowPickingGif && !chooseConf.allowPickingMuitlpleVideo {
                let vc = TZGifPhotoPreviewController()
                let model = TZAssetModel(asset: asset, type: TZAssetModelMediaTypePhotoGif, timeLength: "")
                vc.model = model
                vc.modalPresentationStyle = .fullScreen
                self.getViewController().present(vc, animated: true, completion: nil)
            } else if isVideo && !chooseConf.allowPickingMuitlpleVideo { // 预览视频
                let vc = TZVideoPlayerController()
                let model = TZAssetModel(asset: asset, type: TZAssetModelMediaTypeVideo, timeLength: "")
                vc.model = model
                vc.modalPresentationStyle = .fullScreen
                self.getViewController().present(vc, animated: true, completion: nil)
            } else { // 预览照片
                let photoArray = selectedPhotos.array2NSMutableArray()
                let assetsArray = selectedAssets.array2NSMutableArray()
                let imagePickerVC = TZImagePickerController(selectedAssets: assetsArray, selectedPhotos: photoArray, index: indexPath.item)
                imagePickerVC?.maxImagesCount = chooseConf.maxCount
                imagePickerVC?.allowPickingGif = chooseConf.allowPickingGif
                imagePickerVC?.allowPickingOriginalPhoto = chooseConf.allowPickingOriginalPhoto
                imagePickerVC?.allowPickingMultipleVideo = chooseConf.allowPickingMuitlpleVideo
                imagePickerVC?.showSelectedIndex = chooseConf.showSelectedIndex
                imagePickerVC?.isSelectOriginalPhoto = isSelectedOringinalPhoto
                imagePickerVC?.modalPresentationStyle = .fullScreen
                imagePickerVC?.didFinishPickingPhotosHandle = { (photos, assets, isSelectedOriginalPhoto) in
                    self.selectedPhotos = photos ?? []
                    self.selectedAssets = assets as? [PHAsset] ?? []
                    self.isSelectedOringinalPhoto = isSelectedOriginalPhoto
                    self.collectionView.reloadData()
                }
                self.getViewController().present(imagePickerVC!, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionHead.reuseID, for: indexPath) as! collectionHead
            view.titleLabel.text = "Head \(indexPath.section)"
            return view
        default:
            fatalError("No Such Kind")
        }
    }
    
}

extension ImagePickerView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: configureView)
        if confScrollView.frame.contains(point) {
            return false
        } else {
            return true
        }
    }
}


// MARK: - TZImagePickerController

extension ImagePickerView {
    
    private func pushTZImagePickerController() {
        if chooseConf.maxCount <= 0 {
            return
        }
        let imagePickerVC = TZImagePickerController(maxImagesCount: chooseConf.maxCount, columnNumber: chooseConf.columnNumber, delegate: self, pushPhotoPickerVc: true)
        
        // MARK: 五类个性化设置，这些参数都可以不传，此时会走默认设置
        
        imagePickerVC?.isSelectOriginalPhoto = isSelectedOringinalPhoto
        
        if chooseConf.maxCount > 1 {
            // 1.设置目前已经选中的图片数组
            imagePickerVC?.selectedAssets = selectedAssets.array2NSMutableArray() // 目前已经选中的图片数组
        }
        
        // 在内部显示拍照按钮
        imagePickerVC?.allowTakePicture = chooseConf.showTakePhotoBtn
        // 在内部显示拍视频按钮
        imagePickerVC?.allowTakeVideo = chooseConf.showTakeVideoBtn
        // 视频最大拍摄时间
        imagePickerVC?.videoMaximumDuration = 10
        imagePickerVC?.uiImagePickerControllerSettingBlock = { (imagePickerController) in
            imagePickerController?.videoQuality = .typeHigh
        }
        //        imagePickerVC?.photoWidth = 1600
        //        imagePickerVC?.photoPreviewMaxWidth = 1600
        
        // 2. 在这里设置imagePickerVc的外观
        
        //        imagePickerVC?.navigationBar.barTintColor = .green
        //        imagePickerVC?.oKButtonTitleColorDisabled = .lightGray
        //        imagePickerVC?.oKButtonTitleColorNormal = .green
        //        imagePickerVC?.navigationBar.isTranslucent = false
        
        imagePickerVC?.iconThemeColor = UIColor(red: 31 / 255.0, green: 185 / 255.0, blue: 34 / 255.0, alpha: 1.0)
        imagePickerVC?.showPhotoCannotSelectLayer = true
        imagePickerVC?.cannotSelectLayerColor = UIColor.white.withAlphaComponent(0.8)
        imagePickerVC?.photoPickerPageUIConfigBlock = { (collectionView, bottomToolBar, previewButtom, originalPhotoButton, originalPhotoLabel, doneButton, numberImageView, numberLabel, divideLine) in
            doneButton?.setTitleColor(.red, for: .normal)
        }
        
        //        imagePickerVC?.assetCellDidSetModelBlock = { (cell, imageView, selectImageView, indexLabel, bottomView, timeLength, videoImgView) in
        //            cell?.contentView.clipsToBounds = true
        //            cell?.contentView.layer.cornerRadius = (cell?.contentView.width ?? 0.0) * 0.5
        //        }
        
        // 3. 设置是否可以选择视频/图片/原图
        imagePickerVC?.allowPickingVideo = chooseConf.allowPickingVideo
        imagePickerVC?.allowPickingImage = chooseConf.allowPickingImage
        imagePickerVC?.allowPickingOriginalPhoto = chooseConf.allowPickingOriginalPhoto
        imagePickerVC?.allowPickingGif = chooseConf.allowPickingGif
        // 是否可以多选视频
        imagePickerVC?.allowPickingMultipleVideo = chooseConf.allowPickingMuitlpleVideo
        
        // 4. 照片排列按修改时间升序
        imagePickerVC?.sortAscendingByModificationDate = chooseConf.sortAscending
        
        //        imagePickerVC?.minImagesCount = 3
        //        imagePickerVC?.alwaysEnableDoneBtn = true
        //
        //        imagePickerVC?.minPhotoWidthSelectable = 3000
        //        imagePickerVC?.minPhotoHeightSelectable = 2000
        
        // 5. 单选模式,maxImagesCount为1时才生效
        imagePickerVC?.showSelectBtn = false
        imagePickerVC?.allowCrop = chooseConf.allowCrop
        imagePickerVC?.needCircleCrop = chooseConf.needCircleCrop
        
        // 设置竖屏下的裁剪尺寸
        let left: CGFloat = 30
        let widthHeight = self.width - 2 * left
        let top = (kscreenHeight - widthHeight) / 2
        imagePickerVC?.cropRect = CGRect(x: left, y: top, width: widthHeight, height: widthHeight)
        imagePickerVC?.scaleAspectFillCrop = true
        
        // 设置横屏下的裁剪尺寸
        //        imagePickerVC?.cropRectLandscape = CGRect(x: (self.height - widthHeight) / 2, y: left, width: widthHeight, height: widthHeight)
        //        imagePickerVC?.cropViewSettingBlock = { (cropView) in
        //            cropView?.layer.borderColor = UIColor.red.cgColor
        //            cropView?.layer.borderWidth = 2.0
        //        }
        
        // 是否允许预览
        //        imagePickerVC?.allowPreview = false
        
        // 修改返回按钮
        //        imagePickerVC?.navLeftBarButtonSettingBlock = { (leftButton) in
        //            leftButton?.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        //            leftButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 20)
        //        }
        //        imagePickerVC?.delegate = self
        
        // StatusBarStyle
        imagePickerVC?.statusBarStyle = .lightContent
        
        // 设置是否显示图片序号
        imagePickerVC?.showSelectedIndex = chooseConf.showSelectedIndex
        
        // 设置拍照时是否需要定位，仅对选择器内部拍照有效，外部拍照的，请拷贝demo时手动把pushImagePickerController里定位方法的调用删掉
        //        imagePickerVC?.allowCameraLocation = false
        
        //        TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info
        // 自定义gif播放方案
        TZImagePickerConfig.sharedInstance()?.gifImagePlayBlock = { (view, imageView, gifData, info) in
            let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
            var animatedImageView: FLAnimatedImageView?
            for subview in imageView?.subviews ?? []{
                if subview.isKind(of: FLAnimatedImageView.self) {
                    animatedImageView = subview as? FLAnimatedImageView
                    animatedImageView?.frame = imageView?.bounds ?? CGRect.zero
                    animatedImageView?.animatedImage = nil
                }
            }
            if animatedImageView == nil {
                animatedImageView = FLAnimatedImageView(frame: imageView?.bounds ?? CGRect.zero)
                animatedImageView?.runLoopMode = RunLoop.Mode.default.rawValue
                imageView?.addSubview(animatedImageView!)
            }
            animatedImageView?.animatedImage = animatedImage
        }
        
        // 设置首选语言
        //        imagePickerVC?.preferredLanguage = "en"
        
        // 设置languageBundle以使用其他语言
        //        imagePickerVC?.languageBundle = Bundle(path: Bundle.main.path(forResource: "tz-ru", ofType: "lproj") ?? "")
        
        // MARK: 到这里结束
        
        // 你可以通过block或者代理，来得到用户选择的照片.
        imagePickerVC?.didFinishPickingPhotosHandle = { ( photos, assets, isSelectOriginalPhoto) in
            
        }
        
        imagePickerVC?.modalPresentationStyle = .fullScreen
        self.getViewController().present(imagePickerVC!, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
            // 无相机权限，做一个友好的提示
            let alertVC = UIAlertController(title: "无法使用相机", message: "请在iPhone的\"设置-隐私-相机\"中允许访问相机", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let settingAction = UIAlertAction(title: "设置", style: .default) { (action) in
                
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(settingAction)
            self.getViewController().present(alertVC, animated: true, completion: nil)
        } else if authStatus == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.takePhoto()
                    }
                }
            }
            // 拍照之前检测相册权限
        } else if PHPhotoLibrary.authorizationStatus().rawValue == 2 { // 已被拒绝，没有相册权限，将无法保存拍的照片
            let alertVC = UIAlertController(title: "无法访问相册", message: "请在iPhone的\"设置-隐私-相册\"中允许访问相册", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let settingAction = UIAlertAction(title: "设置", style: .default) { (action) in
                
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(settingAction)
            self.getViewController().present(alertVC, animated: true, completion: nil)
            
        } else if PHPhotoLibrary.authorizationStatus().rawValue == 0 { // 未请求过相册权限
            TZImageManager.default().requestAuthorization {
                self.takePhoto()
            }
        } else {
            self.pushImagePickerController()
        }
    }
    
    
    private func pushImagePickerController() {
        
        weak var weakSelf = self
        
        TZLocationManager().startLocation(successBlock: { (locations) in
            weakSelf?.location = locations?.first
        }) { (error) in
            weakSelf?.location = nil
        }
        
        let sourceType: UIImagePickerController.SourceType = .camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerVC.sourceType = sourceType
            var mediaTypes: [String] = []
            if chooseConf.showTakeVideoBtn {
                mediaTypes.append(kUTTypeMovie as String)
            }
            if chooseConf.showTakePhotoBtn {
                mediaTypes.append(kUTTypeImage as String)
            }
            if mediaTypes.count != 0 {
                imagePickerVC.mediaTypes = mediaTypes
            }
            self.getViewController().present(imagePickerVC, animated: true, completion: nil)
        } else {
            print("模拟器中无法打开照相机,请在真机中使用")
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension ImagePickerView: UINavigationControllerDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension ImagePickerView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return hasUploadData.count
        } else {
            if selectedPhotos.count >= chooseConf.maxCount {
                return selectedPhotos.count
            }
            if !chooseConf.allowPickingMuitlpleVideo {
                for item in selectedAssets {
                    if item.mediaType == PHAssetMediaType.video {
                        return selectedPhotos.count
                    }
                }
            }
            return selectedPhotos.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebImageCollectionViewCell.reuseId, for: indexPath) as? WebImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            let model = hasUploadData[indexPath.item]
            let url = model?.url ?? ""
            let data = try? Data(contentsOf: Bundle.main.url(forResource: "loading", withExtension: "gif")!)
            let gifImage = UIImage.sd_image(with: data)
            cell.imageView.sd_setImage(with: URL(string: url), placeholderImage: gifImage)
            return cell
        }
        
        if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TZTestCell", for: indexPath) as? TZTestCell else {
                return UICollectionViewCell()
            }
            cell.videoImageView.isHidden = true
            
            if indexPath.item == selectedPhotos.count {
                cell.imageView.image = UIImage(named: "AlbumAddBtn")
                cell.deleteBtn.isHidden = true
                cell.gifLable.isHidden = true
            } else {
                cell.imageView.image = selectedPhotos[indexPath.item]
                cell.asset = selectedAssets[indexPath.item]
                cell.deleteBtn.isHidden = false
            }
            
            if !chooseConf.allowPickingGif {
                cell.gifLable.isHidden = true
            }
            
            cell.deleteBtn.tag = indexPath.item
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
}

// MARK: - LxGridViewDataSource
extension ImagePickerView: LxGridViewDataSource {
    
    /// 以下三个方法为长按排序相关代码
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return indexPath.item < selectedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView!, itemAt sourceIndexPath: IndexPath!, canMoveTo destinationIndexPath: IndexPath!) -> Bool {
        return sourceIndexPath.item < selectedPhotos.count && destinationIndexPath.item < selectedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView!, itemAt sourceIndexPath: IndexPath!, didMoveTo destinationIndexPath: IndexPath!) {
        let image = selectedPhotos[sourceIndexPath.item]
        selectedPhotos.remove(at: sourceIndexPath.item)
        selectedPhotos.insert(image, at: destinationIndexPath.item)
        
        let asset = selectedAssets[sourceIndexPath.item]
        selectedAssets.remove(at: sourceIndexPath.item)
        selectedAssets.insert(asset, at: destinationIndexPath.item)
        collectionView.reloadData()
    }
}

extension ImagePickerView {
    @objc private func deleteBtnAction(_ sender: UIButton) {
        if self.collectionView(collectionView, numberOfItemsInSection: 0) <= selectedPhotos.count {
            selectedPhotos.remove(at: sender.tag)
            selectedAssets.remove(at: sender.tag)
            collectionView.reloadData()
            return
        }
        
        selectedPhotos.remove(at: sender.tag)
        selectedAssets.remove(at: sender.tag)
        collectionView.performBatchUpdates({
            let indexPath = IndexPath(item: sender.tag, section: 0)
            self.collectionView.deleteItems(at: [indexPath])
        }) { (finished) in
            self.collectionView.reloadData()
        }
    }
}

extension ImagePickerView {
    private func printAssetsName(_ assets: [PHAsset]) {
        for item in assets {
            print(item.description)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerView: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let type = info[UIImagePickerController.InfoKey.mediaType] as? String
        let tzImagePickerVC = TZImagePickerController(maxImagesCount: 1, delegate: self)
        tzImagePickerVC?.sortAscendingByModificationDate = chooseConf.sortAscending
        tzImagePickerVC?.showProgressHUD()
        if type == "public.image" {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            let meta = info[UIImagePickerController.InfoKey.mediaType] as? [AnyHashable : Any]
            
            TZImageManager.default()?.savePhoto(with: image, meta: meta, location: self.location, completion: { (asset, error) in
                tzImagePickerVC?.hideProgressHUD()
                if error != nil {
                    print("图片保存失败\(String(describing: error?.localizedDescription))")
                } else {
                    let assesModel = TZImageManager.default()?.createModel(with: asset)
                    if self.chooseConf.allowCrop {
                        // 允许裁剪，去裁剪
                        let imagePicker = TZImagePickerController(cropTypeWith: asset, photo: image) { (cropImage, asset) in
                            self.refreshCollectionViewWithAddedAsset(asset: asset ?? PHAsset(), image: cropImage ?? UIImage())
                        }
                        imagePicker?.allowPickingImage = true
                        imagePicker?.needCircleCrop = self.chooseConf.needCircleCrop
                        imagePicker?.circleCropRadius = 100
                        if let vc = imagePicker {
                            self.getViewController().present(vc, animated: true, completion: nil)
                        }
                    } else {
                        self.refreshCollectionViewWithAddedAsset(asset: assesModel?.asset ?? PHAsset(), image: image ?? UIImage())
                    }
                }
            })
            
        } else if type == "public.movie" {
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            if let url = videoURL {
                TZImageManager.default()?.saveVideo(with: url, location: location, completion: { (asset, error) in
                    tzImagePickerVC?.hideProgressHUD()
                    if error == nil {
                        let assetModel = TZImageManager.default()?.createModel(with: asset)
                        TZImageManager.default()?.getPhotoWith(assetModel?.asset, completion: { (photo, info, isDegraded) in
                            
                            if let unwrapPhoto = photo, isDegraded == false {
                                self.refreshCollectionViewWithAddedAsset(asset: assetModel?.asset ?? PHAsset(), image: unwrapPhoto)
                            }
                            
                        })
                    }
                })
            }
        }
    }
    
    func refreshCollectionViewWithAddedAsset(asset: PHAsset, image: UIImage) {
        selectedAssets.append(asset)
        selectedPhotos.append(image)
        collectionView.reloadData()
        
        if asset.isKind(of: PHAsset.self) {
            let phAsset = asset
            print("location:\(String(describing: phAsset.location))")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if picker.isKind(of: UIImagePickerController.self) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - TZImagePickerControllerDelegate
extension ImagePickerView: TZImagePickerControllerDelegate {
    
    /// 用户点击了取消
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        print("cancel")
    }
    
    /// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
    /// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
    /// - Parameters:
    ///   - picker:
    ///   - photos: photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
    ///   - assets: 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
    ///   - isSelectOriginalPhoto: 如果isSelectOriginalPhoto为YES，表明用户选择了原图
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        selectedPhotos = photos
        selectedAssets = assets as? [PHAsset] ?? []
        self.isSelectedOringinalPhoto = isSelectOriginalPhoto
        collectionView.reloadData()
        
        // 1.打印图片名字
        self.printAssetsName(selectedAssets)
        // 2.图片位置信息
        for phAsset in selectedAssets {
            print("Location is \(String(describing: phAsset.location?.description))")
        }
        // 3.获取原图的示例，用队列限制最大并发为1，避免内存暴增
        self.operationQueue = OperationQueue()
        self.operationQueue?.maxConcurrentOperationCount = 1
        
        for i in 0..<assets.count {
            let asset = assets[i] as! PHAsset
            
            let operation = ImageUploadOperation(asset: asset, completion: { (photo, info, isDegraded) in
                if isDegraded {
                    return
                }
                let name = asset.description
                // MARK: 图片上传
                MBProgressHUD.showAdded(to: self, animated: true)
                SMImageManager.shared.uploadImage(photo, fileName: name) { () in
                    if let vc = self.getViewController() as? ImagePickerViewController {
                        vc.request()
                        MBProgressHUD.hide(for: self, animated: true)
                    }
                }
                print("图片获取&&上传完成")
            }) { (progress, error, stop, info) in
                print("获取原图进度：\(progress)")
            }
            self.operationQueue?.addOperation(operation)
        }
    }
    
    /// 如果用户选择了一个视频且allowPickingMultipleVideo是NO，下面的代理方法会被执行
    ///
    /// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        selectedPhotos = [coverImage]
        selectedAssets = [asset]
        TZImageManager.default().getVideoOutputPath(with: asset, presetName: AVAssetExportPresetLowQuality, success: { (outputPath) in
            print("视频导出到本地完成，沙盒路径为\(String(describing: outputPath))")
        }) { (errorMessage, error) in
            print("视屏导出失败:\(String(describing: errorMessage)),error:\(String(describing: error))")
        }
        collectionView.reloadData()
    }
    
    /// 如果用户选择了一个gif图片且allowPickingMultipleVideo是NO，下面的代理方法会被执行
    ///
    /// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: PHAsset!) {
        selectedPhotos = [animatedImage]
        selectedAssets = [asset]
        collectionView.reloadData()
    }
    
    /// 决定相册显示与否
    func isAlbumCanSelect(_ albumName: String!, result: PHFetchResult<AnyObject>!) -> Bool {
        //        if albumName == "个人收藏" {
        //            return false
        //        }
        //        if albumName == "Wheel" {
        //            return false
        //        }
        //        if albumName == "视频" {
        //            return false
        //        }
        return true
    }
    
    /// 决定asset显示与否
    func isAssetCanSelect(_ asset: PHAsset!) -> Bool {
        
        //        switch asset.mediaType {
        //        case .video:
        //            let duration = asset.duration
        //            print(duration)
        //        case .image:
        //            return asset.pixelWidth < 3000 || asset.pixelHeight < 3000
        //        case .audio:
        //            return false
        //        case .unknown:
        //            return false
        //        default:
        //            break
        //        }
        return true
    }
}

extension ImagePickerView: ConfigureViewDelegate {
    func valueChanged<T>(sender: T) {
        if let view = sender.self as? UISwitch {
            switch view.tag {
            case 0:
                chooseConf.showTakePhotoBtn = view.isOn
            case 1:
                chooseConf.sortAscending = view.isOn
            case 2:
                chooseConf.allowPickingVideo = view.isOn
            case 3:
                chooseConf.allowPickingOriginalPhoto = view.isOn
            case 4:
                chooseConf.allowPickingImage = view.isOn
            case 5:
                chooseConf.allowPickingGif = view.isOn
            case 6:
                chooseConf.showSheet = view.isOn
            case 7:
                chooseConf.allowCrop = view.isOn
            case 8:
                chooseConf.allowPickingMuitlpleVideo = view.isOn
            case 9:
                chooseConf.needCircleCrop = view.isOn
            case 10:
                chooseConf.showTakeVideoBtn = view.isOn
            case 11:
                chooseConf.showSelectedIndex = view.isOn
            default:
                break
            }
        }
        if let view = sender.self as? UITextField {
            print(view)
            if view.tag == 0 {
                chooseConf.maxCount = Int(view.text ?? "") ?? 9
            }else if view.tag == 1 {
                chooseConf.columnNumber = Int(view.text ?? "") ?? 4
            }
        }
        print("Changed")
    }
    
}
