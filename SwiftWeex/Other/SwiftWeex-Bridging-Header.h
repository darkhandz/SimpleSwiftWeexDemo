//
//  SwiftWeex-Bridging-Header.pch
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/5.
//  Copyright © 2018年 delite. All rights reserved.
//

#ifndef SwiftWeex_Bridging_Header_pch
#define SwiftWeex_Bridging_Header_pch

/// weex插件管理器
#import "WeexPluginManager.h"

/// weex module
#import "WXMapViewModule.h"
#import "WXSystemUtilModule.h"
#import "WXImagePickerModule.h"
#import "WXAlipayModule.h"
#import "WXWechatModule.h"

/// 高德导航
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

/// 支付宝
#import <AlipaySDK/AlipaySDK.h>

/// 微信
#import <WXApi.h>

#endif /* SwiftWeex_Bridging_Header_pch */
