//
//  WXAlipayModule.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/8.
//  Copyright © 2018年 delite. All rights reserved.
//

import Foundation
import WeexSDK

/// weex回调
fileprivate var mcallback: WXModuleCallback?


public extension WXAlipayModule {
    /// 调起支付宝
    @objc func aliPay(_ orderStr: String) {
        invokeAlipay(orderStr: orderStr)
    }
    
    /// 调起支付宝
    @objc func aliPay(_ orderStr: String, callback: WXModuleCallback?) {
        mcallback = callback
        invokeAlipay(orderStr: orderStr)
    }
    
    /// 调起支付宝
    fileprivate func invokeAlipay(orderStr: String) {
        // 监听AppDelegate方式回调过来的结果
        NotificationCenter.default.addObserver(forName: DKNotification.alipayResultCallback.name,
                                               object: nil, queue: nil)
        { [weak self] noti in
            Log("alipay result:", noti.object)
            guard let dict = noti.object as? [AnyHashable: Any] else { return }
            self?.processResult(dict)
        }
        AlipaySDK.defaultService().payOrder(orderStr, fromScheme: AppScheme) { [weak self] dict in
            Log("alipay result:", dict)
            self?.processResult(dict)
        }
    }
    
    /// 处理支付宝返回的结果 - https://docs.open.alipay.com/204/105302
    fileprivate func processResult(_ dict: [AnyHashable: Any]?) {
        guard let resultStatus = dict?["resultStatus"] as? String else {
            Log("结果未知")
            mcallback?(["code": "-1", "msg": "支付失败，结果未知"])
            return
        }
        let result = AlipayResult(rawValue: resultStatus) ?? .unknown
        if result.isSuccess {
            mcallback?(["code": "0", "msg": result.description])
        } else {
            mcallback?(["code": "-2", "msg": result.description])
        }
    }
}


// MARK: - 辅助类型定义
extension WXAlipayModule {
    /// 支付宝支付结果码
    enum AlipayResult: String, CustomStringConvertible{
        /// 支付成功
        case success      = "9000"
        /// 用户中途取消
        case userCancel   = "6001"
        /// 支付失败
        case fail         = "4000"
        /// 网络连接出错
        case networkError = "6002"
        /// 未知错误
        case unknown
        
        /// 支付是否成功
        var isSuccess: Bool {
            return self == .success
        }
        
        /// 文字描述
        var description: String {
            switch self {
            case .success:
                return "支付成功"
            case .userCancel:
                return "用户取消"
            case .fail:
                return "支付失败"
            case .networkError:
                return "网络连接错误"
            case .unknown:
                return "未知错误"
            }
        }
    }
}
