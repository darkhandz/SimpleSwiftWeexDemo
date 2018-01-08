//
//  WXSystemUtilModule.m
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/7.
//  Copyright © 2018年 delite. All rights reserved.
//

#import "WXSystemUtilModule.h"

@implementation WXSystemUtilModule
@synthesize weexInstance;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
WX_EXPORT_METHOD(@selector(call:))
#pragma clang diagnostic pop

@end
