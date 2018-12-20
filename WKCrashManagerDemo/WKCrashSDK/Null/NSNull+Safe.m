//
//  NSNull+Safe.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/7.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSNull+Safe.h"
#import "WKSwizzle.h"
#import "NSObject+MsgReceiver.h"
@implementation NSNull (Safe)

+ (void)registerNullCrash
{
    swizzling_exchangeMethod([self class], @selector(forwardingTargetForSelector:), @selector(wknullsafe_forwardingTargetForSelector:));
}

- (id)wknullsafe_forwardingTargetForSelector:(SEL)aSelector
{
    static NSArray * stubObjArr = nil;
    if (!stubObjArr) {
        stubObjArr = @[@"",@0,@[],@{}];
    }
    for (id obj in stubObjArr) {
        if ([obj respondsToSelector:aSelector]) {
            WKCrashModel * model = [WKCrashModel new];
            model.clasName = NSStringFromClass([self class]);
            model.msg = [NSString stringWithFormat:@"send %@'s method %@ to null",NSStringFromClass([obj class]),NSStringFromSelector(aSelector)];
            model.threadStack = [NSThread callStackSymbols];
            [WKCrashReport crashInfo:model type:(WKCrashType_Null)];
            return obj;
        }
    }
    return [self wknullsafe_forwardingTargetForSelector:aSelector];
}

@end

