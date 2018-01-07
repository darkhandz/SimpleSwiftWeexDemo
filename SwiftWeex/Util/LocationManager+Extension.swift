//
//  LocationManager+Extension.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/6.
//  Copyright © 2018年 delite. All rights reserved.
//

import UIKit
import CoreLocation

class LocationUtil: NSObject {
    static let shared = LocationUtil()
    /// 当前最新定位坐标
    var currentLocation = CLLocation()
    fileprivate var locationMgr = CLLocationManager()
    private override init (){
        super.init()
        locationMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationMgr.delegate = self
    }
    
    func requestLocationAuth() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationMgr.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationMgr.startUpdatingLocation()
        case .denied, .restricted:
            alert()
        }
    }
    
    func alert() {
        let vc = UIAlertController(title: "定位授权", message: "请打开本App的定位授权才可以正常使用", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "前往设置", style: .default, handler: { _ in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        vc.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }
    }
}

extension LocationUtil: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last {
            currentLocation = last
        }
    }
}
