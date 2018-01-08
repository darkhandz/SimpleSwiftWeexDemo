//
//  Constant.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/5.
//  Copyright © 2018年 delite. All rights reserved.
//

import Foundation

/// 还是要你在Info.plist里面改的
let AppScheme = "yunshengpark"

/// 还是要你在Info.plist里面改的
let WXAppID = "wx8a64d6e72fdac5bd"

/// weex 的资源路径
let WeexBundleFolder = String(format: "file://%@/bundlejs/", Bundle.main.bundlePath)



// MARK: - 通知名
/// 通知名
enum DKNotification : String{
    /// 支付宝支付结果
    case alipayResultCallback
    /// 微信SDK结果
    case wechatResultCallback
    
    var name: NSNotification.Name{
        return NSNotification.Name(self.rawValue)
    }
}
