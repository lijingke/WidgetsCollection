//
//  ImageUploadOperation.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/20.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation
import TZImagePickerController

class ImageUploadOperation: TZImageRequestOperation {
    override func start() {
        print("ImageUploadOperation Start")
        isExecuting = true

        // MARK: - 获取&上传大图

//        DispatchQueue.global(qos: .default).async {
//            TZImageManager.default()?.getPhotoWith(self.asset, completion: { (photo, info, isDegraded) in
//                if !isDegraded {
//                    if let completedBlock = self.completedBlock {
//                        completedBlock(photo!, info!, isDegraded)
//                    }
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.done()
//                    }
//                }
//            }, progressHandler: { (progress, error, stop, info) in
//                DispatchQueue.main.async {
//                    if let progressBlock = self.progressBlock {
//                        progressBlock(progress, error!, stop!, info!)
//                    }
//                }
//            }, networkAccessAllowed: true)
//        }

        // MARK: - 获取&上传原图

        TZImageManager.default()?.getOriginalPhoto(with: asset, progressHandler: { progress, error, stop, info in
            DispatchQueue.main.async {
                if let progressBlock = self.progressBlock {
                    progressBlock(progress, error!, stop!, info!)
                }
            }
        }, newCompletion: { photo, info, isDegraded in
            DispatchQueue.main.async {
                if !isDegraded {
                    if let completeBlock = self.completedBlock {
                        completeBlock(photo!, info!, isDegraded)
                    }
//                    SMImageManager.shared.getToken()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.done()
                    }
                }
            }
        })
    }

    override func done() {
        super.done()
    }
}
