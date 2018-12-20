//
//  NSMutableSet+Safe.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/6.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSMutableSet+Safe.h"
#import "WKSwizzle.h"
#import "NSObject+MsgReceiver.h"
#import "WKCrashManager.h"
@implementation NSMutableSet (Safe)

+ (void)registerMutableSetCrash
{
        swizzling_exchangeMethod(NSClassFromString(@"__NSSetM"), @selector(addObject:), @selector(wksafe_addObject:));
        swizzling_exchangeMethod(NSClassFromString(@"__NSSetM"), @selector(removeObject:), @selector(wksafe_removeObject:));
}

- (void)wksafe_removeObject:(id)object
{
    if (object) {
        [self wksafe_removeObject:object];
    }
    else
    {
        [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
    }
}
-(void)wksafe_addObject:(id)object
{
    if (object) {
        [self wksafe_addObject:object];
    }
    else
    {
        [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
    }
}


@end


