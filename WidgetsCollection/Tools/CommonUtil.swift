//
//  CommonUtil.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/15.
//

import AVFoundation
import CoreImage
import Foundation
import MBProgressHUD
import SnapKit
import SwiftyJSON
import UserNotifications
import WebKit

class CommonUtil: NSObject {
    /// 正则，找出指定字符串
    static func regexGetSub(pattern: String, str: String) -> [String] {
        var subStr: [String] = []
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: str, options: [], range: NSRange(str.startIndex..., in: str))
        for match in matches {
            let matchStr = (str as NSString).substring(with: match.range)
            subStr.append(matchStr)
        }
        return subStr
    }
    
    class public func getCurrentVc() -> UIViewController {
        let rootVc = UIApplication.shared.keyWindow?.rootViewController
        let currentVc = getCurrentVcFrom(rootVc!)
        return currentVc
    }
    
    class private func getCurrentVcFrom(_ rootVc: UIViewController) -> UIViewController {
        var currentVc: UIViewController
        var rootCtr = rootVc
        if rootCtr.presentedViewController != nil {
            rootCtr = rootVc.presentedViewController!
        }
        if rootVc.isKind(of: UITabBarController.classForCoder()) {
            currentVc = getCurrentVcFrom((rootVc as! UITabBarController).selectedViewController!)
        } else if rootVc.isKind(of: UINavigationController.classForCoder()) {
            currentVc = getCurrentVcFrom((rootVc as! UINavigationController).visibleViewController!)
        } else {
            currentVc = rootCtr
        }
        return currentVc
    }

    /// 去重 except:排除
    static func repetArr(_ arr: [String], _ except: [String]) -> [String] {
        var result: [String] = []
        for str in arr {
            var find = false
            var isExcept = false
            for exceStr in except {
                if str == exceStr {
                    isExcept = true
                    continue
                }
            }
            for string in result {
                if string == str {
                    find = true
                    continue
                }
            }
            if !find, !isExcept {
                result.append(str)
            }
        }

        return result
    }

    /// 获取包名
    static func getiIdentifier() -> String {
        let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
        return identifier
    }

    /// 转换2位数字符串
    static func getDoubleStr(_ value: Double) -> String {
        let str = String(format: "%.2lf", value)
        return str
    }

    /// 去掉+86
    static func getPhonNo86(phone: String) -> String {
        if phone.hasPrefix("+86-") {
            return phone.getSubString(startIndex: 4, endIndex: phone.count - 1)
        }
        return phone
    }

    /// 获取隐藏中间号码段的电话号
    static func getPhoneHide(phone: String) -> String {
        if phone.count < 11 {
            return phone
        }
        var str = phone.getSubString(startIndex: 0, endIndex: 2)
        str.append("****")
        str.append(phone.getSubString(startIndex: 7, endIndex: 10))
        return str
    }

    /// 增加通知监听
    static func register(_ obver: Any, _ sel: Selector, _ name: String) {
        NotificationCenter.default.addObserver(obver, selector: sel, name: NSNotification.Name(rawValue: name), object: nil)
    }

    /// 发送通知
    static func sendNotify(_ name: String, _ obj: Any?) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: obj)
    }

    /// 打开URL
    static func open(url: String) {
        let urlS = URL(string: url)!
        UIApplication.shared.open(urlS, options: [:]) { _ in
        }
    }

    // 屏幕宽度
    static var scW: CGFloat {
        return UIScreen.main.bounds.width
    }

    // 屏幕高度
    static var scH: CGFloat {
        return UIScreen.main.bounds.height
    }

    /// 拨打电话
    static func telPhone(num: String) {
        let urlString = "tel://\(num)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:]) { _ in
            }
        }
    }

    static func isNull(string: Any?) -> Bool {
        if string == nil {
            return true
        }
        let bo = string as? String ?? ""
        if bo.count == 0 {
            return true
        }
        return false
    }

    /// 根据阿拉伯数字，返回对应星期
    static func getWeak(weak: Int) -> String {
        switch weak {
        case 1:
            return "一"
        case 2:
            return "二"
        case 3:
            return "三"
        case 4:
            return "四"
        case 5:
            return "五"
        case 6:
            return "六"
        case 7:
            return "天"
        default:
            return ""
        }
    }

    @objc static func getBundleName() -> String {
        var bundlePath = Bundle.main.bundlePath
        bundlePath = bundlePath.components(separatedBy: "/").last!
        bundlePath = bundlePath.components(separatedBy: ".").first!
        return bundlePath
    }

    /// 是否可以使用通知
    static func isEnabelNotifi() -> Bool {
        let seting = UIApplication.shared.currentUserNotificationSettings
        if Int(seting?.types.rawValue ?? 0) == 0 {
            return false
        }
        return true
    }

    /// 发送本地推送
    static func postLocalNotification(title: String?, body: String, userInfo: [AnyHashable: Any]) {
        Log.info("---发送自定义通知22---")
        let content = UNMutableNotificationContent()
        content.title = title ?? ""
        content.subtitle = ""
        content.body = body
        content.userInfo = userInfo
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(1), repeats: false)
        let request = UNNotificationRequest(identifier: "CustomNotify", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    // 发起本地通知
    static func postLocalNotification(title: String?, body: String) {
        Log.info("---发送自定义通知---")
        postLocalNotification(title: title, body: body, userInfo: [:])
    }

    // 打开相册
    static func openPhoto(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, from: UIViewController, allowEdit: Bool, sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = delegate
            imagePicker.allowsEditing = allowEdit
            from.present(imagePicker, animated: true, completion: nil)
        }
    }

    // 开启或关闭闪光灯
    static func openLight(isOpen: Bool) {
        let device = AVCaptureDevice.default(for: .video)
        if (device?.hasTorch)! {
            let torchMode = isOpen ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
            let flashMode = isOpen ? AVCaptureDevice.FlashMode.on : AVCaptureDevice.FlashMode.off
            if device?.torchMode != torchMode ||
                device?.flashMode != flashMode
            {
                do {
                    try device?.lockForConfiguration()
                    device?.torchMode = torchMode
                    device?.flashMode = flashMode
                    device?.unlockForConfiguration()
                } catch let error as NSError {
                    Log.info(error.localizedDescription)
                }
            }
        }
    }

    // 开启系统震动
    static func openShake(isShake: Bool, sound: Bool) {
        if isShake {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        if sound {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(NSURL(fileURLWithPath: Bundle.main.path(forResource: "scan_res.bundle/ring", ofType: "wav")!), &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }

    // 验证手机号
    static func validatePhone(phone: String) -> Bool {
        let regex = "^[1]\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: phone)
    }

    // 验证邮箱
    static func validateEmail(email: String) -> Bool {
        let regex = "[\\w]+(\\.[\\w]+)*@[\\w]+(\\.[\\w]+)+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

    static func toInt(_ obj: Any?) -> Int {
        let value = "\(obj ?? "0")".toInt()
        return value
    }

    static func getStringByRangeIntValue(Str: NSString, location: Int, length: Int) -> Int {
        let a = Str.substring(with: NSRange(location: location, length: length))
        let intValue = (a as NSString).integerValue
        return intValue
    }

    // 打开系统设置
    static func openSetingPage() {
        let url = URL(string: UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: {
                _ in
            })
        }
    }

    // 创建随机图，开发测试用
    static func getImage() -> String {
        let imaArr = ["https://i.loli.net/2021/07/08/jrYoKUayFEA6nzW.jpg", "https://i.loli.net/2020/04/22/Bwle4p5CI6tsA89.jpg", "https://i.loli.net/2020/04/21/ZndNLWFUSRlyDtV.png", "https://i.loli.net/2020/09/29/AH5QurNT46bDilm.jpg"]
        return imaArr.randomElement() ?? ""
    }

//    static func showMessage(_ msg: String?) {
//        SYPIndicatorView.show(msg)
//
//    }
//
//    static func showTopMessage(_ msg: String?) {
//        SYPIndicatorView.showTopString(msg)
//    }
}

extension CommonUtil {
    static func clearWebCache() {
        let recordType = WKWebsiteDataStore.allWebsiteDataTypes()
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: recordType) { records in
            WKWebsiteDataStore.default().removeData(ofTypes: recordType, for: records) {
                Log.info("清理完成")
            }
        }
    }
}
