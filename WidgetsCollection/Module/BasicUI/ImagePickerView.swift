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

protocol ImagePickerViewDelegate: NSObjectProtocol {
    func didClickSettingBtn()
}

class ImagePickerView: UIView {
    
    weak var delegate:ImagePickerViewDelegate?
    
    public var selectedPhotos: [UIImage] = []
    public var selectedAssets: [PHAsset] = []
    
    private var isSelectedOringinalPhoto: Bool = true
    private var itemWH: CGFloat!
    private var margin: CGFloat!
    private var location: CLLocation!
    
    /// 是否允许拍照
    public var showTakePhotoBtn: Bool = true
    /// 照片是否按修改时间升序排列
    public var sortAscending: Bool = true
    /// 是否允许选择视频
    public var allowPickingVideo: Bool = true
    /// 是否允许选择照片原图
    public var allowPickingOriginalPhoto: Bool = true
    /// 是否允许选择照片
    public var allowPickingImage: Bool = true
    /// 是否允许选择Gif图片
    public var allowPickingGif: Bool = true
    /// 把照片/拍视频按钮放在外面
    public var showSheet: Bool = true
    /// 照片最大可选张数
    public var maxCount: Int = 9
    /// 每行展示照片张数
    public var columnNumber: Int = 4
    /// 单选模式下是否允许裁剪
    public var allowCrop: Bool = true
    /// 是否允许多选视频/GIF/图片
    public var allowPickingMuitlpleVideo: Bool = true
    /// 是否使用圆形裁剪框
    public var needCircleCrop: Bool = true
    /// 是否允许拍视频
    public var showTakeVideoBtn: Bool = true
    /// 是否在右上角显示图片选中序号
    public var showSelectedIndex: Bool = true
    
    public var subView: ConfigureView!
    
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
        let width = self.width - 2 * self.margin - 4
        self.itemWH = width / 3 - self.margin
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
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
        self.subView = subView
        self.showTakePhotoBtn = subView.showSheetSwitch.isOn
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        view.backgroundColor = UIColor.init(displayP3Red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        return view
    }()
    
}

// MARK: -
extension ImagePickerView {
    @objc func tapAction() {
        configureView.removeFromSuperview()
    }
}

// MARK: - UICollectionViewDelegate
extension ImagePickerView: UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if indexPath.item == selectedPhotos.count {
            if showSheet {
                var takePhotoTitle = "拍照"
                if showTakeVideoBtn && showTakePhotoBtn {
                    takePhotoTitle = "相机"
                } else if showTakeVideoBtn {
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
            
            if filename.contains("GIF") && allowPickingGif && !allowPickingMuitlpleVideo {
                let vc = TZGifPhotoPreviewController()
                let model = TZAssetModel(asset: asset, type: TZAssetModelMediaTypePhotoGif, timeLength: "")
                vc.model = model
                vc.modalPresentationStyle = .fullScreen
                self.getViewController().present(vc, animated: true, completion: nil)
            } else if isVideo && !allowPickingMuitlpleVideo { // 预览视频
                let vc = TZVideoPlayerController()
                let model = TZAssetModel(asset: asset, type: TZAssetModelMediaTypeVideo, timeLength: "")
                vc.model = model
                vc.modalPresentationStyle = .fullScreen
                self.getViewController().present(vc, animated: true, completion: nil)
            } else { // 预览照片
                let photoArray = selectedPhotos.array2NSMutableArray()
                let assetsArray = selectedAssets.array2NSMutableArray()
                let imagePickerVC = TZImagePickerController(selectedAssets: assetsArray, selectedPhotos: photoArray, index: indexPath.item)
                imagePickerVC?.maxImagesCount = maxCount
                imagePickerVC?.allowPickingGif = allowPickingGif
                imagePickerVC?.allowPickingOriginalPhoto = allowPickingOriginalPhoto
                imagePickerVC?.allowPickingMultipleVideo = self.allowPickingMuitlpleVideo
                imagePickerVC?.showSelectedIndex = showSelectedIndex
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
}

// MARK: - TZImagePickerController

extension ImagePickerView {
    
    private func pushTZImagePickerController() {
        if maxCount <= 0 {
            return
        }
        let imagePickerVC = TZImagePickerController(maxImagesCount: maxCount, columnNumber: columnNumber, delegate: self, pushPhotoPickerVc: true)
        
        // 五类个性化设置，这些参数都可以不传，此时会走默认设置
        
        imagePickerVC?.isSelectOriginalPhoto = isSelectedOringinalPhoto
        
        if self.maxCount > 1 {
            // 1.设置目前已经选中的图片数组
            imagePickerVC?.selectedAssets = selectedAssets.array2NSMutableArray() // 目前已经选中的图片数组
        }
        
        // 在内部显示拍照按钮
        imagePickerVC?.allowTakePicture = showTakePhotoBtn
        // 在内部显示拍视频按钮
        imagePickerVC?.allowTakeVideo = showTakeVideoBtn
        // 视频最大拍摄时间
        imagePickerVC?.videoMaximumDuration = 10
        imagePickerVC?.uiImagePickerControllerSettingBlock = { (imagePickerController) in
            imagePickerController?.videoQuality = .typeHigh
        }
//        imagePickerVC?.photoWidth = 1600
//        imagePickerVC?.photoPreviewMaxWidth = 1600
        
        // 2. 在这里设置imagePickerVc的外观
        
        // 3. 设置是否可以选择视频/图片/原图
        imagePickerVC?.allowPickingVideo = allowPickingVideo
        imagePickerVC?.allowPickingImage = allowPickingImage
        imagePickerVC?.allowPickingOriginalPhoto = allowPickingOriginalPhoto
        imagePickerVC?.allowPickingGif = allowPickingGif
        // 是否可以多选视频
        imagePickerVC?.allowPickingMultipleVideo = allowPickingMuitlpleVideo
        
        // 4. 照片排列按修改时间升序
        imagePickerVC?.sortAscendingByModificationDate = sortAscending
        
        // 5.
        imagePickerVC?.showSelectBtn = false
        imagePickerVC?.allowCrop = allowCrop
        imagePickerVC?.needCircleCrop = needCircleCrop
        
        // 设置竖屏下的裁剪尺寸
        let left: CGFloat = 30
        let widthHeight = self.width - 2 * left
        let top = (self.width - widthHeight) / 2
        imagePickerVC?.cropRect = CGRect(x: left, y: top, width: widthHeight, height: widthHeight)
        imagePickerVC?.scaleAspectFillCrop = true
        
        imagePickerVC?.statusBarStyle = .lightContent
        
        // 设置是否显示图片序号
        imagePickerVC?.showSelectedIndex = showSelectedIndex
        
        // 设置拍照时是否需要定位，仅对选择器内部拍照有效，外部拍照的，请拷贝demo时手动把pushImagePickerController里定位方法的调用删掉
//        imagePickerVC?.allowCameraLocation = false
        
//        TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info
        // 自定义gif播放方案
        TZImagePickerConfig.sharedInstance()?.gifImagePlayBlock = { (view, imageView, gifData, info) in
//            let animatedImage =
            
        }
        
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
            if showTakeVideoBtn {
                mediaTypes.append(kUTTypeMovie as String)
            }
            if showTakePhotoBtn {
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

// MARK: - UICollectionViewDataSource
extension ImagePickerView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedPhotos.count >= maxCount {
            return selectedPhotos.count
        }
        if !allowPickingMuitlpleVideo {
            for item in selectedAssets {
                if item.mediaType == PHAssetMediaType.video {
                    return selectedPhotos.count
                }
            }
        }
        return selectedPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        
        if !self.allowPickingGif {
            cell.gifLable.isHidden = true
        }
        
        cell.deleteBtn.tag = indexPath.item
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
}

// MARK: - LxGridViewDataSource
extension ImagePickerView: LxGridViewDataSource {
    
    /// 以下三个方法为长按排序相关代码
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
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
        tzImagePickerVC?.sortAscendingByModificationDate = sortAscending
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
                    if self.allowCrop {
                        // 允许裁剪，去裁剪
                        let imagePicker = TZImagePickerController(cropTypeWith: asset, photo: image) { (cropImage, asset) in
                            self.refreshCollectionViewWithAddedAsset(asset: asset ?? PHAsset(), image: cropImage ?? UIImage())
                        }
                        imagePicker?.allowPickingImage = true
                        imagePicker?.needCircleCrop = self.needCircleCrop
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
        
        //todo: 上传图片
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
        return true
    }
    
    /// 决定asset显示与否
    func isAssetCanSelect(_ asset: PHAsset!) -> Bool {
        return true
    }
}

extension ImagePickerView: ConfigureViewDelegate {
    func valueChanged<T>(sender: T) {
        if let view = sender.self as? UISwitch {
            switch view.tag {
            case 0:
                showTakePhotoBtn = view.isOn
            case 1:
                sortAscending = view.isOn
            case 2:
                allowPickingVideo = view.isOn
            case 3:
                allowPickingOriginalPhoto = view.isOn
            case 4:
                allowPickingImage = view.isOn
            case 5:
                allowPickingGif = view.isOn
            case 6:
                showSheet = view.isOn
            case 7:
                allowCrop = view.isOn
            case 8:
                allowPickingMuitlpleVideo = view.isOn
            case 9:
                needCircleCrop = view.isOn
            case 10:
                showTakeVideoBtn = view.isOn
            case 11:
                showSelectedIndex = view.isOn
            default:
                break
            }
        }
        if let view = sender.self as? UITextField {
            print(view)
            if view.tag == 0 {
                maxCount = Int(view.text ?? "") ?? 9
            }else if view.tag == 1 {
                columnNumber = Int(view.text ?? "") ?? 4
            }
        }
        print("Changed")
     }

}
