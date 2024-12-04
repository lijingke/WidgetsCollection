//
//  WebImageCacheManager.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/4.
//

import Foundation

class WebImageCacheManager: NSObject {
    class func readCacheFromUrl(url: String) -> Data? {
        let path = WebImageCacheManager.getFullCachePathFromUrl(url: url)
        if FileManager.default.fileExists(atPath: path) {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            return data
        }
        return nil
    }

    class func writeCacheToUrl(url: String, data: Data?) {
        let path = WebImageCacheManager.getFullCachePathFromUrl(url: url)
        let pathURL = URL(filePath: path)
        try? data?.write(to: pathURL)
    }

    // 设置缓存路径
    class func getFullCachePathFromUrl(url: String) -> String {
        var chchePath = NSHomeDirectory() + "/Library/Caches/MyCache"
        let fileManager = FileManager.default
        fileManager.fileExists(atPath: chchePath)
        if !(fileManager.fileExists(atPath: chchePath)) {
            do {
                try fileManager.createDirectory(atPath: chchePath, withIntermediateDirectories: true)

            } catch {}
        }
        // 进行字符串处理
        var newURL: String
        newURL = WebImageCacheManager.stringToCustomString(str: NSString(string: url)) ?? ""
        let trian = String(format: "/%@", newURL)
        chchePath += trian
        return chchePath
    }

    // 删除缓存
    class func removeAllCache() {
        let chchePath = NSHomeDirectory() + "/Library/Caches/MyCache"
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: chchePath) {
            try? fileManager.removeItem(atPath: chchePath)
        }
    }

    class func stringToCustomString(str: NSString) -> String? {
        let newStr = NSMutableString()
        for i in 0 ..< str.length {
            let c: unichar = str.character(at: i)
            if (c >= 48 && c <= 57) || (c >= 65 && c <= 90) || (c >= 97 && c <= 122) {
                newStr.appendFormat("%c", c)
            }
        }
        return newStr.copy() as? String
    }
}
