//
//  WXAmapModule+Extension.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/7.
//  Copyright © 2018年 delite. All rights reserved.
//

import Foundation
import WeexSDK


/// 导航组件
fileprivate var compositeManager : AMapNaviCompositeManager!
/// 高德地图搜索组件
fileprivate let mapSearch = AMapSearchAPI()
/// weex回调
fileprivate var mcallback: WXModuleCallback?



public extension WXMapViewModule {
    /// 获取用户当前位置，回调传给weex
    @objc func getUserLocation(_ callback: WXModuleCallback) {
        let city = AMapLocationUtil.shared.currentCity
        let locNative = LocationUtil.shared.currentLocation.coordinate
        let locAmap = AMapLocationUtil.shared.currentLocation.coordinate
        if locAmap.latitude > 0 && locAmap.longitude > 0 {
            callback(["result": "success", "data": ["position": ["\(locAmap.longitude)", "\(locAmap.latitude)", city] ]])
        } else {
            callback(["result": "success", "data": ["position": ["\(locNative.longitude)", "\(locNative.latitude)", city] ]])
        }
        Log(locNative, locAmap, city)
    }
    
    /// 开启高德导航，起点是用户当前位置，终点是参数
    @objc func openAmapNavi(_ desLongitude: String, _ desLatitude: String, callback: WXModuleCallback?) {
        compositeManager = AMapNaviCompositeManager()
        // 如果需要使用AMapNaviCompositeManagerDelegate的相关回调（如自定义语音、获取实时位置等），需要设置delegate
        // compositeManager.delegate = self
        guard let lati = Float(desLatitude), let long = Float(desLongitude) else {
            Log("传入经纬度不正确")
            return
        }
        let destination = AMapNaviPoint.location(withLatitude: CGFloat(lati), longitude: CGFloat(long))
        let destName = "终点"
        let config = AMapNaviCompositeUserConfig()
        // 跳过路径规划，直接进入导航界面
        //config.setStartNaviDirectly(true)
        config.setRoutePlanPOIType(AMapNaviRoutePlanPOIType.end, location: destination!, name: destName, poiId: nil)
        compositeManager.presentRoutePlanViewController(withOptions: config)
    }
    
    /// 在指定城市里搜索包含keyword的POI
    @objc func poiSearch(_ keyword: String, _ city: String, _ unuse: Bool, callback: WXModuleCallback?) {
        Log("keyword:", keyword, "city:", city)
        mapSearch?.delegate = self
        mcallback = callback
        // 构建搜索
        let req = AMapPOIKeywordsSearchRequest()
        req.keywords = keyword
        req.city = city
        req.requireExtension = true
        req.cityLimit = true
        req.requireSubPOIs = true
        // 发起搜索，等待回调
        mapSearch?.aMapPOIKeywordsSearch(req)
    }
}



// MARK: - POI搜索回调
extension WXMapViewModule: AMapSearchDelegate {
    public func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.pois.isEmpty {
            Log("无POI结果")
            mcallback?([])
            return
        }
        // weex不识别这里的对象，自己手段转成字典数组
        let pois = response.pois.map{ poi in
            return ["uid": poi.uid, "name": poi.name, "type": poi.type, "typecode": poi.typecode,
                    "location": ["latitude": poi.location.latitude, "longitude": poi.location.longitude],
                    "point": ["latitude": poi.location.latitude, "longitude": poi.location.longitude],
                    "address": poi.address, "tel": poi.tel, "distance": poi.distance, "parkingType": poi.parkingType,
                    "postcode": poi.postcode, "province": poi.province, "city": poi.city, "citycode": poi.citycode,
                    "district": poi.district, "adcode": poi.adcode
            ]
        }
        mcallback?(pois)
    }
    
    public func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        Log("搜索POI失败")
    }
}



