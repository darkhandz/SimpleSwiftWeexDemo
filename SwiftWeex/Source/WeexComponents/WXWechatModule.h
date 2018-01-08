//
//  WXWechatModule.h
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/8.
//  Copyright © 2018年 delite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

/*
 WXApi的相关头文件里面有如下定义：
 typedef NS_ENUM(NSInteger,WXLogLevel){
     WXLogLevelNormal = 0,      // 打印日常的日志
     WXLogLevelDetail = 1,      // 打印详细的日志
 };
 
 自行修改为：
 typedef NS_ENUM(NSInteger,WeiXinLogLevel){
     WeiXinLogLevelNormal = 0,      // 打印日常的日志
     WeiXinLogLevelDetail = 1,      // 打印详细的日志
 };
 
*/
@interface WXWechatModule : NSObject <WXModuleProtocol>

@end
