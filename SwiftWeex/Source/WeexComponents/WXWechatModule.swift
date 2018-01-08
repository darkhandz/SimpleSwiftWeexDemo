//
//  WXWechatModule.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/8.
//  Copyright © 2018年 delite. All rights reserved.
//

import Foundation
import WeexSDK


/// weex回调
fileprivate var mcallback: WXModuleCallback?


public extension WXWechatModule {
    /// 检查微信是否已安装
    @objc func isWXInstalled() -> Bool {
        return WXApi.isWXAppInstalled()
    }
    
    /// 调起微信支付
    @objc func weChatPay(_ json: String) {
        invokeWechat(json: json)
    }
    
    /// 调起微信支付
    @objc func weChatPay(_ json: String, callback: WXModuleCallback?) {
        mcallback = callback
        invokeWechat(json: json)
    }
    
    /// 调起微信支付
    fileprivate func invokeWechat(json: String) {
        guard isWXInstalled() else {
            Log("未安装微信")
            mcallback?(["code": "-1", "msg": WechatResult.unknown.description])
            return
        }
        // 注册appID
        WXApi.registerApp(WXAppID)
        // 监听AppDelegate方式回调过来的结果
        NotificationCenter.default.addObserver(forName: DKNotification.wechatResultCallback.name,
                                               object: nil, queue: nil)
        { [weak self] noti in
            guard let url = noti.object as? URL else { return }
            // app被微信回调时处理结果（用在appdelegate的handleOpenURL这一类回调方法里）
            WXApi.handleOpen(url, delegate: self)
        }
        
        guard let data = json.data(using: .utf8),
            let params = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            Log("支付参数有误")
            mcallback?(["code": "-4", "msg": "支付参数有误"])
            return
        }
        
        guard let appid = params["appid"] as? String, let partnetID = params["partnerid"] as? String,
              let prepayID = params["prepayid"] as? String, let sign = params["sign"] as? String,
              let nonceStr = params["noncestr"] as? String, let package = params["package"] as? String,
              let timestamp = params["timestamp"] as? Double else {
            Log("订单参数不完整")
            mcallback?(["code": "-3", "msg": "订单参数不完整"])
            return
        }
        WXApi.registerApp(appid)
        let req = PayReq()
        req.partnerId   = partnetID
        req.prepayId    = prepayID
        req.nonceStr    = nonceStr
        req.timeStamp   = UInt32(timestamp)
        req.package     = package
        req.sign        = sign
        WXApi.send(req)
        Log("准备叫微信干活", appid, req.partnerId, req.prepayId, req.nonceStr, req.timeStamp, req.package, req.sign)
    }
    
    /// 微信分享的方法, type - 1好友,2朋友圈
    @objc func weChatShare(_ link: String, _ title: String, _ content: String, _ thumbURL: String, _ type: Int, callback: WXModuleCallback?) {
        guard isWXInstalled() else {
            Log("未安装微信")
            callback?(["code": "-1", "msg": WechatResult.unknown.description])
            return
        }
        mcallback = callback
        // 注册appID
        WXApi.registerApp(WXAppID)
        
        let ext = WXWebpageObject()
        ext.webpageUrl = link
        
        let msg = WXMediaMessage()
        msg.title = title
        msg.description = content
        msg.mediaObject = ext
        msg.mediaTagName = "WECHAT_TAG_JUMP_APP"
        //msg.setThumbImage(thumb)
        
        let req = SendMessageToWXReq()
        req.message = msg
        // 0 - 对话， 1 - 朋友圈
        req.scene = Int32(type == 1 ? 0 : 1)
        WXApi.send(req)
    }
    
}



// MARK: - 微信SDK处理结果回调
extension WXWechatModule : WXApiDelegate {
    // MARK: - WXApi的代理方法
    /// 收到微信发来的要求，要求本app提供内容，具体看官方demo，我用不上，懒得实现 --- darkhandz
    public func onReq(_ req: BaseReq!) {
    }
    
    /// 收到微信发来的响应（响应我们用WXApi发出的请求）
    public func onResp(_ resp: BaseResp!) {
        Log("wechat result:", resp)
        // 支付返回结果，实际支付结果需要去服务器端查询
        if let payResp = resp as? PayResp {
            let result = WechatResult(rawValue: Int(payResp.errCode)) ?? .unknown
            if result.isSuccess {
                mcallback?(["code": "0", "msg": "支付成功"])
            } else {
                mcallback?(["code": "-2", "msg": result.description])
            }
        // 分享结果返回
        } else if let msgResp = resp as? SendMessageToWXResp {
            Log("微信分享结果: ", msgResp.errCode)
            let result = WechatResult(rawValue: Int(msgResp.errCode)) ?? .unknown
            switch result {
            case .success:
                mcallback?(["code": "0", "msg": "分享成功"])
            case .userCancel:
                mcallback?(["code": "-4", "msg": "已取消"])
            default:
                mcallback?(["code": "5", "msg": "分享失败"])
            }
        }
    }
    
}



extension WXWechatModule {
    /// 微信SDK返回结果类型
    enum WechatResult : Int, CustomStringConvertible {
        
        case success    =  0   /**< 成功                */
        case common     = -1   /**< 普通错误类型         */
        case userCancel = -2   /**< 用户点击取消并返回    */
        case sentFail   = -3   /**< 发送失败            */
        case authDeny   = -4   /**< 授权失败            */
        case unsupport  = -5   /**< 微信不支持          */
        case unknown    = -99  /**< 返回未知的错误       */
        case unInstalled = -8888 // 未安装微信
        
        /// 是否成功（成功包括支付成功，登录授权成功）
        var isSuccess: Bool {
            return self == .success
        }
        
        /// 错误描述
        var description: String {
            switch self {
            case .success:
                return "成功"
            case .common:
                return "通用错误"
            case .userCancel:
                return "用户取消"
            case .sentFail:
                return "发送请求失败"
            case .authDeny:
                return "拒绝授权"
            case .unsupport:
                return "不支持的请求"
            case .unknown:
                return "未知错误"
            case .unInstalled:
                return "未安装微信"
            }
        }
    }
}
