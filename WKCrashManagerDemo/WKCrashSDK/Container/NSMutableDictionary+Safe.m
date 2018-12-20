//
//  NSMutableDictionary+Safe.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/6.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import "WKSwizzle.h"
#import "NSObject+MsgReceiver.h"
#import "WKCrashManager.h"
@implementation NSMutableDictionary (Safe)

+ (void)registerMutableDictionaryCrash
{

    swizzling_exchangeMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), @selector(wksafe_setObject:forKey:));
    swizzling_exchangeMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(wksafe_setObject:forKeyedSubscript:));
    swizzling_exchangeMethod(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:), @selector(wksafe_removeObjectForKey:));

}

- (void)wksafe_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (aKey && anObject) {
        [self wksafe_setObject:anObject forKey:aKey];
        return;
    }
//    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
    
}

- (void)wksafe_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (key && obj) {
        [self wksafe_setObject:obj forKeyedSubscript:key];
        return;
    }
//    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
}

- (void)wksafe_removeObjectForKey:(id)aKey
{
    if (aKey) {
        [self wksafe_removeObjectForKey:aKey];
        return;
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
}

@end

