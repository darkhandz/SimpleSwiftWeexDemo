//
//  AMapLocationManager.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/8.
//  Copyright © 2018年 delite. All rights reserved.
//

import Foundation

class AMapLocationUtil: NSObject {
    static let shared = AMapLocationUtil()
    /// 当前最新定位坐标
    var currentLocation = CLLocation()
    /// 当前定位城市
    var currentCity = ""
    fileprivate var locationMgr = AMapLocationManager()
    private override init (){
        super.init()
        locationMgr.delegate = self
        //定位最小更新距离
        locationMgr.distanceFilter = 20
        locationMgr.locatingWithReGeocode = true
        locationMgr.startUpdatingLocation()
    }
}


// MARK: - 定位结果回调
extension AMapLocationUtil: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        if let loc = location {
            currentLocation = loc
        }
        if let regeo = reGeocode, let city = regeo.city {
            currentCity = city
        }
    }
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        Log("定位出错：", error.localizedDescription)
    }
}
