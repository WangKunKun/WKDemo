//
//  NSDictionary+Safe.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/5.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "WKSwizzle.h"
#import "NSObject+MsgReceiver.h"
#import "WKCrashManager.h"
@implementation NSDictionary (Safe)

+ (void)registerDictonaryCrash
{
        swizzling_exchangeMethod(NSClassFromString(@"__NSPlaceholderDictionary"), @selector(initWithObjects:forKeys:count:), @selector(wksafe_initWithObjects:forKeys:count:));
}

- (instancetype)wksafe_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt
{
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
            continue;
        }
        newObjects[index] = objects[i];
        newkeys[index] = keys[i];
        index++;
    }
    
    return [self wksafe_initWithObjects:newObjects forKeys:newkeys count:index];
}


@end



