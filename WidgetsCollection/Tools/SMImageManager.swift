//
//  SMImageManager.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/20.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

class SMImageManager {
    
    private static let sharedInstance = SMImageManager()
    
    var completionHandlers: (()->())?
    
    static var shared: SMImageManager {
        return sharedInstance
    }
}

extension SMImageManager {
    
    public func testAlamofire() {
        AF.request("https://httpbin.org/get").response { (response) in
            debugPrint(response)
        }
    }
    
    public func getUserInfo() {
        let urlStr = SMDomainURL + ProfileAPI
        let headers: HTTPHeaders = [.authorization("uU0SeGTlcGYzasZixa5d0RNYuVv7zy0U"),.contentType("application/x-www-form-urlencoded")]
        AF.request(urlStr, method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let dict = json as? Dictionary<String,AnyObject>, let data = dict["data"] as? Dictionary<String,AnyObject> {
                    if let model = JSONDeserializer<UserInfoModel>.deserializeFrom(dict: data) {
                        print(model)
                    }
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 获取图片历史上传记录
    public func getUploadHistory(_ closure: @escaping ((_ models: [UploadHistoryModel?])->())) {
        let urlStr = SMDomainURL + UploadHistoryAPI
        let headers: HTTPHeaders = [.authorization("uU0SeGTlcGYzasZixa5d0RNYuVv7zy0U"),.contentType("application/x-www-form-urlencoded")]
        AF.request(urlStr, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let dict = json as? Dictionary<String,AnyObject>, let data = dict["data"] as? Array<Any> {
                    if let models = JSONDeserializer<UploadHistoryModel>.deserializeModelArrayFrom(array: data) {
                        print(models)
                        closure(models)
                    }
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func getToken() {
        let urlStr = SMDomainURL + TokenAPI
        let headers: HTTPHeaders = [.authorization("uU0SeGTlcGYzasZixa5d0RNYuVv7zy0U"),.contentType("application/x-www-form-urlencoded")]
        let parameters = ["username":"lijingke","password":"7F7ru6wNrfbL4wVv"]
        
        AF.request(urlStr, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseJSON { (data) in
            print(data)
        }
        
        
    }
    
    public func uploadImage(_ image: UIImage, fileName: String, _ closure: @escaping (()->())) {
        let urlStr = SMDomainURL + UploadAPI
        let headers: HTTPHeaders = [.authorization("uU0SeGTlcGYzasZixa5d0RNYuVv7zy0U"),.contentType("application/x-www-form-urlencoded")]
        
        AF.upload(multipartFormData: { (data) in
            let imageData = image.jpegData(compressionQuality: 0.5)
            let parameterName = "smfile"
            data.append(imageData!, withName: parameterName, fileName: fileName, mimeType: "image/jpg")
        }, to: urlStr, method: .post, headers: headers).responseJSON { (response) in
            closure()
        }
    }
}
