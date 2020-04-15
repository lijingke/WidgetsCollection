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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        
        let settingItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(settingAction))
        
        navigationItem.rightBarButtonItems = [addItem, settingItem]
        
        view.addSubview(settingView)
        settingView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    @objc private func addPhoto() {
        pushTZImagePickerController()
    }
    
    @objc private func settingAction() {
        UIView.animate(withDuration: 1) {
            self.settingView.isHidden.toggle()
        }
    }
    
    private func pushTZImagePickerController() {
        let pickerVC = TZImagePickerController()
        pickerVC.pickerDelegate = self
        pickerVC.showSelectedIndex = true
        present(pickerVC, animated: true, completion: nil)
    }
    
    lazy var settingView: ConfigureView = {
        let view = Bundle(for: ConfigureView.self).loadNibNamed("ConfigureView", owner: nil, options: nil)?.first as! ConfigureView
        view.backgroundColor = .cyan
        view.isHidden = true
        return view
    }()
    
}

extension ImagePickerViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        print(photos.description)
    }
}
