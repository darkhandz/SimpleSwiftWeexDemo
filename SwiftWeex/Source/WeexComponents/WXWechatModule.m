//
//  WXWechatModule.m
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/8.
//  Copyright © 2018年 delite. All rights reserved.
//

#import "WXWechatModule.h"

@implementation WXWechatModule
@synthesize weexInstance;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
WX_EXPORT_METHOD(@selector(weChatPay:))
WX_EXPORT_METHOD(@selector(weChatPay:callback:))
WX_EXPORT_METHOD(@selector(weChatShare:::::callback:))
#pragma clang diagnostic pop

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
