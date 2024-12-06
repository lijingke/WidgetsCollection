//
//  GetLocationViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/11/7.
//  Copyright © 2019 李京珂. All rights reserved.
//

import CoreLocation
import UIKit

class GetLocationViewController: BaseViewController {
    var currentLocation: CLLocation!
    var lock = NSLock()

    lazy var locationManager: CLLocationManager = {
        let location = CLLocationManager()
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.distanceFilter = 50
        return location
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }

    fileprivate func callUserLocation() {
        locationManager.startUpdatingLocation()
        print("Start Location")
    }

    override func viewWillAppear(_: Bool) {}

    @objc fileprivate func checkLocationAuthority() {
        openLocationServiceWithBlock { [weak self] authority in

            guard let weakSelf = self else {
                return
            }

            if authority == false {
                if self?.locationManager.authorizationStatus == .notDetermined {
                    self?.locationManager.requestAlwaysAuthorization()
                } else {
                    let alertCon = UIAlertController(title: "获取定位失败", message: "请跳转到设置页面开启定位", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                        let callUrl = URL(string: "tel://110")
                        UIApplication.shared.open(callUrl!, options: [:], completionHandler: nil)
                    }
                    let okAction = UIAlertAction(title: "设定", style: .default) { _ in
                        let openUrl = URL(string: UIApplication.openSettingsURLString)
                        UIApplication.shared.open(openUrl!, options: [:]) { _ in
                            print("Finish")
                        }
                    }
                    alertCon.addAction(cancelAction)
                    alertCon.addAction(okAction)
                    weakSelf.present(alertCon, animated: true) {
                        print("End")
                    }
                }
            } else {
                self?.callUserLocation()
            }
        }
    }

    fileprivate func configureUI() {
        view.addSubview(getLocationBtn)
        getLocationBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        getLocationBtn.setNeedsLayout()
        getLocationBtn.layoutIfNeeded()
        getLocationBtn.layer.cornerRadius = getLocationBtn.frame.height / 2
    }

    lazy var getLocationBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Click Me", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        btn.addTarget(self, action: #selector(checkLocationAuthority), for: .touchDown)
        return btn
    }()

    fileprivate func showAlert(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, name: String) {
        let alertC = UIAlertController(title: "定位成功！", message: "你的纬度是:\(String(format: "%0.6f", latitude))\n你的经度是:\(String(format: "%0.6f", longitude))\n你的海拔是:\(String(format: "%0.2f", altitude))\n\n你的位置是:\(name)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertC.addAction(okAction)
        present(alertC, animated: true, completion: nil)
    }
}

extension GetLocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let canLocation = manager.authorizationStatus != .notDetermined || manager.authorizationStatus != .denied
        if canLocation {
            callUserLocation()
        }
    }

    func openLocationServiceWithBlock(action: @escaping ((Bool) -> Void)) {
        var isOpen = false
        if CLLocationManager.locationServicesEnabled() && (locationManager.authorizationStatus != .denied && locationManager.authorizationStatus != .notDetermined) {
            isOpen = true
        }
        action(isOpen)
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        lock.lock()
        currentLocation = locations.last
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        let altitude = currentLocation.altitude

        print("定位经度为：\(latitude)")
        print("定位纬度为：\(longitude)")
        print("定位海拔为：\(altitude)")

        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            if placemarks!.count > 0 {
                let placeMark = placemarks?.first
                let country = placeMark?.country ?? ""
                let administrativeArea = placeMark?.administrativeArea ?? ""
                let locality = placeMark?.locality ?? ""
                let subLocality = placeMark?.subLocality ?? ""
                let thoroughfare = placeMark?.thoroughfare ?? ""

                let address = country + administrativeArea + locality + subLocality + thoroughfare

                self.showAlert(latitude: latitude, longitude: longitude, altitude: altitude, name: address)
            } else if error == nil && placemarks?.count == 0 {
                print("没有地址返回")
            } else if error != nil {
                print("location error\(String(describing: error))")
            }
        }
//        lock.unlock()
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print("定位出错啦！！\(error)")
    }
}
