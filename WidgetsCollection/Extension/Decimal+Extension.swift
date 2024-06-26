//
//  Decimal+Extension.swift
//  CustomizationGlass
//
//  Created by 李京珂 on 2021/7/20.
//

import UIKit

public extension CGFloat {
    /// 四舍五入，保留小数位数，精度小数 places=2 =>  1234.56789 =1234.57
    func roundTo(_ places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }

    /// 不四舍五入，保留对应小数位数
    func roundToCGFloat(_ places: Int) -> CGFloat {
        /// 这里很坑，必须标明接收的变量为CGFloat，否则精度丢失
        let divisor: CGFloat = pow(CGFloat(10.0), CGFloat(places))
        let intV = Int(self * divisor)
        let floV = CGFloat(intV) / CGFloat(divisor)
        return floV
    }

    /// 不四舍五入，保留对应小数位数
    func roundToStr(_ places: Int) -> String {
        return String(format: "%.\(places)lf", self)
    }

    /// 四舍五入，保留对应小数位数
    func roundToStr2(_ places: Int) -> String {
        let floV = roundTo(places)
        return String(format: "%.\(places)lf", floV)
    }
}

public extension Double {
    /// 四舍五入，保留小数位数，精度小数 places=2 =>  1234.56789 =1234.57
    func roundTo(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    /// 不四舍五入，保留对应小数位数
    func roundToDouble(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let intV = Int(self * divisor)
        let douV = Double(intV) / divisor
        return douV
    }

    /// 四舍五入，保留对应小数位数
    func roundToStr2(_ places: Int) -> String {
        let douV = roundTo(places)
        return String(format: "%.\(places)lf", douV)
    }

    /// 不四舍五入，保留对应小数位数
    func roundToStr(_ places: Int) -> String {
        let douV = roundToDouble(places)
        return String(format: "%.\(places)lf", douV)
    }
}
