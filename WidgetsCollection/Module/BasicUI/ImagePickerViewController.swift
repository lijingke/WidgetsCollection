//
//  ImagePickerViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/14.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit
import TZImagePickerController

class ImagePickerViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
        
    // MARK: - 懒加载
    lazy var mainView: ImagePickerView = {
        let view = ImagePickerView()
        view.delegate = self
        return view
    }()
    
}

// MARK: - ImagePickerViewDelegate
extension ImagePickerViewController: ImagePickerViewDelegate {
    func didClickSettingBtn() {
        
    }
}

// MARK: - UI
extension ImagePickerViewController {
    
    private func setupUI() {
        setupNavi()
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavi() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        
        let settingItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(settingAction))
        
        navigationItem.rightBarButtonItems = [addItem, settingItem]
    }

}

// MARK: - ClickEvent
extension ImagePickerViewController {
    
    @objc private func addPhoto() {
        pushTZImagePickerController()
    }
    
    @objc private func settingAction() {
        
        if mainView.configureView.isDescendant(of: mainView) {
            mainView.configureView.removeFromSuperview()
        } else {
            UIView.animate(withDuration: 1) {
                self.mainView.addSubview(self.mainView.configureView)
                self.mainView.configureView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    fileprivate func modalPush() {
        let vc = OtherViewController()
        navigationController?.pushViewController(vc, animated: true)
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .overCurrentContext
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true, completion: nil)
    }
    
    private func pushTZImagePickerController() {
        let pickerVC = TZImagePickerController()
        pickerVC.pickerDelegate = self
        pickerVC.showSelectedIndex = true
        present(pickerVC, animated: true, completion: nil)
    }
}

// MARK: - TZImagePickerControllerDelegate
extension ImagePickerViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        print(photos.description)
    }
}
