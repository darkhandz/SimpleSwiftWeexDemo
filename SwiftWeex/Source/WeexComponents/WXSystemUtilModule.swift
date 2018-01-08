//
//  WXSystemUtilModule.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/7.
//  Copyright © 2018年 delite. All rights reserved.
//

import Foundation

public extension WXSystemUtilModule {
    
    @objc func call(_ phoneNumber: String) {
        guard let url = URL(string: "tel:" + phoneNumber) else {
            Log("号码\(phoneNumber)不正确！")
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
