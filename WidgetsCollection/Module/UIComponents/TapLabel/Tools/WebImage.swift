//
//  WebImage.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/4.
//

import Foundation
import UIKit

extension UIImageView {
    /**
     *设置web图片
     *url:图片路径
     *defaultImage:默认缺省图片
     *isCache：是否进行缓存的读取
     */
    func setWebImage(url: String?, defaultImage: String?, isCache: Bool) {
        var ZYHImage: UIImage?
        if url == nil {
            return
        }
        // 设置默认图片
        if defaultImage != nil {
            image = UIImage(named: defaultImage!)
        }

        if isCache {
            if let data = WebImageCacheManager.readCacheFromUrl(url: url ?? "") {
                ZYHImage = UIImage(data: data)
                image = ZYHImage
            } else {
                let backgroundQueue = DispatchQueue(label: "background_queue",
                                                    qos: .background)

                backgroundQueue.async { [weak self] in
                    // Call the class you need here and it will be done on a background QOS
                    if let URL = URL(string: url ?? "") {
                        let data = try? Data(contentsOf: URL)
                        if data != nil {
                            ZYHImage = UIImage(data: data! as Data)
                            // 写缓存
                            WebImageCacheManager.writeCacheToUrl(url: url!, data: data)
                            DispatchQueue.main.async {
                                // 刷新主UI
                                self?.image = ZYHImage
                            }
                        }
                    }
                }
            }
        } else {
            DispatchQueue.global().sync {
                if let URL = URL(string: url ?? "") {
                    let data = try? Data(contentsOf: URL)
                    if data != nil {
                        ZYHImage = UIImage(data: data!)
                        // 写缓存
                        DispatchQueue.main.async {
                            // 刷新主UI
                            self.image = ZYHImage
                        }
                    }
                }
            }
        }
    }
}
