//
//  AppDelegate.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/5.
//  Copyright © 2018年 delite. All rights reserved.
//

import UIKit
import WeexSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configWeex()
        configAMap()
        /// 开始定位
        let _ = LocationUtil.shared
        
        let vc = ViewController()
        vc.jsURL = URL(string: WeexBundleFolder + "index.js")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        return true
    }
    
    /// iOS 9+ 回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        handleByAlipay(url: url)
        handleByWechat(url: url)
        return true
    }
}


// MARK: - 各种配置加载
extension AppDelegate {
    
    /// 初始化weex配置
    fileprivate func configWeex() {
        // 基本信息
        WXAppConfiguration.setAppGroup("delite")
        WXAppConfiguration.setAppName("SwiftWeexDemo")
        WXAppConfiguration.setAppVersion("1.0.0")
        
        // Log详细程度
        WXLog.setLogLevel(.log)
        
        // 注册各种module，component，handler
        WXSDKEngine.registerHandler(WXImageLoader(), with: WXImgLoaderProtocol.self)
        WXSDKEngine.registerModule("phone", with: WXSystemUtilModule.self)
        WXSDKEngine.registerModule("imagePicker", with: WXImagePickerModule.self)
        WXSDKEngine.registerModule("ali", with: WXAlipayModule.self)
        WXSDKEngine.registerModule("wechat", with: WXWechatModule.self)
        
        // 初始化 WeexSDK
        WXSDKEngine.initSDKEnvironment()
        
        // 加载通过weex plugin add xxx添加的插件
        WeexPluginManager.registerWeexPlugin()
    }
    
    /// 初始化高德地图
    fileprivate func configAMap() {
        AMapServices.shared().enableHTTPS = true
        // 这里由web前端在初始化weex-amap的时候就赋值了
        // AMapServices.shared().apiKey = ""
    }
    
    /// 支付宝 处理付款回调（App被杀的情况下）
    fileprivate func handleByAlipay(url: URL) {
        guard url.host == "safepay" else { return }
        // 处理支付结果
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { dict in
            NotificationCenter.default.post(name: DKNotification.alipayResultCallback.name, object: dict)
        }
    }
    
    /// 微信 处理回调
    fileprivate func handleByWechat(url: URL) {
        NotificationCenter.default.post(name: DKNotification.wechatResultCallback.name, object: url)
    }
}

