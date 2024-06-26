//
//  SMImageManager.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/20.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Alamofire
import HandyJSON
import UIKit

class SMImageManager {
    private static let sharedInstance = SMImageManager()

    var completionHandlers: (() -> Void)?

    static var shared: SMImageManager {
        return sharedInstance
    }
}

extension SMImageManager {
    public func testAlamofire() {
        AF.request("https://httpbin.org/get").response { response in
            debugPrint(response)
        }
    }

    public func getUserInfo(_ closure: @escaping ((_ model: UserInfoModel?) -> Void)) {
        let urlStr = SMDomainURL + ProfileAPI
        let headers: HTTPHeaders = [.authorization("uU0SeGTlcGYzasZixa5d0RNYuVv7zy0U"), .contentType("application/x-www-form-urlencoded")]
        AF.request(urlStr, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case let .success(json):
                if let dict = json as? [String: AnyObject], let data = dict["data"] as? [String: AnyObject] {
                    if let model = JSONDeserializer<UserInfoModel>.deserializeFrom(dict: data) {
                        closure(model)
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    // 获取图片历史上传记录
    public func getUploadHistory(_ closure: @escaping ((_ models: [UploadHistoryModel?]) -> Void)) {
        let urlStr = SMDomainURL + UploadHistoryAPI
        let headers: HTTPHeaders = [.authorization("uU0SeGTlcGYzasZixa5d0RNYuVv7zy0U"), .contentType("application/x-www-form-urlencoded")]
        AF.request(urlStr, headers: headers).responseJSON { response in
            switch response.result {
            case let .success(json):
                if let dict = json as? [String: AnyObject], let data = dict["data"] as? [Any] {
                    if let models = JSONDeserializer<UploadHistoryModel>.deserializeModelArrayFrom(array: data) {
                        closure(models)
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    public func getToken() {
        let urlStr = SMDomainURL + TokenAPI
        let headers: HTTPHeaders = [.authorization("uU0SeGTlcGYzasZixa5d0RNYuVv7zy0U"), .contentType("application/x-www-form-urlencoded")]
        let parameters = ["username": "lijingke", "password": "7F7ru6wNrfbL4wVv"]

        AF.request(urlStr, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseJSON { data in
            print(data)
        }
    }

    public func uploadImage(_ image: UIImage, fileName: String, _ closure: @escaping (() -> Void)) {
        let urlStr = SMDomainURL + UploadAPI
        let headers: HTTPHeaders = [.authorization("uU0SeGTlcGYzasZixa5d0RNYuVv7zy0U"), .contentType("application/x-www-form-urlencoded")]

        AF.upload(multipartFormData: { data in
            let imageData = image.jpegData(compressionQuality: 0.5)
            let parameterName = "smfile"
            data.append(imageData!, withName: parameterName, fileName: fileName, mimeType: "image/jpg")
        }, to: urlStr, method: .post, headers: headers).responseJSON { _ in
            closure()
        }
    }
}
