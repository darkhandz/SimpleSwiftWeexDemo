//
//  WXAmapModule+Extension.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/7.
//  Copyright © 2018年 delite. All rights reserved.
//

import Foundation
import WeexSDK

public extension WXMapViewModule {
    @objc func getUserLocation(_ callback: WXModuleCallback) {
        let loc = LocationUtil.shared.currentLocation.coordinate
        Log(loc)
        callback(["result": "success", "data": ["position": [loc.longitude, loc.latitude], "title": "中山市"] ])
    }
}
