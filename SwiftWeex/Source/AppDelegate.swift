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
        
        let vc = ViewController()
        vc.jsURL = URL(string: WeexBundleFolder + "index.js")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
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
        
        // 初始化 WeexSDK
        WXSDKEngine.initSDKEnvironment()
    }
}

