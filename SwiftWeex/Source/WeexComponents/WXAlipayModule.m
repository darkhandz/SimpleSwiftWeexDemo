//
//  WXAlipayModule.m
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/8.
//  Copyright © 2018年 delite. All rights reserved.
//

#import "WXAlipayModule.h"

@implementation WXAlipayModule
@synthesize weexInstance;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
WX_EXPORT_METHOD(@selector(aliPay:))
WX_EXPORT_METHOD(@selector(aliPay:callback:))
#pragma clang diagnostic pop

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
