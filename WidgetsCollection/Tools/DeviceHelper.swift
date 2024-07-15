//
//  DeviceHelper.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/15.
//

import DeviceKit
import Foundation

class DeviceHelper: NSObject {
    /// 屏幕宽度
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

    /// 屏幕高度
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    /// 获取设备版本号
    static func deviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1": return "iPod Touch 5"
        case "iPod7,1": return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE (1st generation)"
        case "iPhone9,1", "iPhone9,3": return "iPhone 7"
        case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,5", "iPhone10,2": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,4", "iPhone11,6": return "iPhone XS MAX"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone12,8": return "iPhone SE (2nd generation)"
        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone14,6": return "iPhone SE (3rd generation)"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad6,11", "iPad6,12": return "iPad 5"
        case "iPad7,5", "iPad7,6": return "iPad 6"
        case "iPad7,11", "iPad7,12": return "iPad 7"
        case "iPad11,6", "iPad11,7": return "iPad 8"
        case "iPad12,1", "iPad12,2": return "iPad 9"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad11,3", "iPad11,4": return "iPad Air 3"
        case "iPad13,1", "iPad13,2": return "iPad Air 4"
        case "iPad13,16", "iPad13,17": return "iPad Air 5"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad11,1", "iPad11,2": return "iPad Mini 5"
        case "iPad14,1", "iPad14,2": return "iPad Mini 6"
        case "iPad6,7", "iPad6,8", "iPad6,3", "iPad6,4", "iPad7,1", "iPad7,2", "iPad7,3", "iPad7,4", "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4", "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8", "iPad8,9", "iPad8,10", "iPad8,11", "iPad8,12": return "iPad Pro"
        case "AppleTV5,3": return "Apple TV"
        case "i386", "x86_64": return "Simulator"
        default: return identifier
        }
    }

    /// 获取iPhone名称
    static func iphoneName() -> String {
        return UIDevice.current.name
    }

    /// 获取app版本号
    static func appVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }

    /// 获取电池电量
    static func batteryLevel() -> CGFloat {
        return CGFloat(UIDevice.current.batteryLevel)
    }

    /// 当前系统名称
    static func systemName() -> String {
        return UIDevice.current.systemName
    }

    /// 当前设备型号
    @objc static func systemModel() -> String {
        return Device.current.description
    }

    /// 当前系统版本号
    static func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /// 通用唯一识别码UUID
    static func UUID() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }

    /// 获取当前设备IP
    static func deviceIP() -> String? {
        var addresses = [String]()
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP | IFF_RUNNING | IFF_LOOPBACK)) == (IFF_UP | IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                            if let address = String(validatingUTF8: hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }

    /// 私有方法
    private static func blankof<T>(type _: T.Type) -> T {
        let ptr = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.size)
        let val = ptr.pointee
        ptr.deinitialize(count: 0)
        return val
    }

    /// 获取总内存大小
    static func totalRAM() -> Int64 {
        var fs = blankof(type: statfs.self)
        if statfs("/var", &fs) >= 0 {
            return Int64(UInt64(fs.f_bsize) * fs.f_blocks)
        }
        return -1
    }

    /// 获取当前可用内存
    static func availableRAM() -> Int64 {
        var fs = blankof(type: statfs.self)
        if statfs("/var", &fs) >= 0 {
            return Int64(UInt64(fs.f_bsize) * fs.f_bavail)
        }
        return -1
    }

    /// 获取电池当前的状态，共有4种状态
    static func batteryState() -> String {
        let device = UIDevice.current
        if device.batteryState == UIDevice.BatteryState.unknown {
            return "unknown"
        } else if device.batteryState == UIDevice.BatteryState.unplugged {
            return "unplugged"
        } else if device.batteryState == UIDevice.BatteryState.charging {
            return "charging"
        } else if device.batteryState == UIDevice.BatteryState.full {
            return "full"
        }
        return ""
    }

    /// 获取当前语言
    static func deviceLanguage() -> String {
        return Locale.preferredLanguages[0]
    }
}
