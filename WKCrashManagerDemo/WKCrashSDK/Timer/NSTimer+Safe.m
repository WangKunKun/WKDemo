//
//  NSTimer+Safe.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/7.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSTimer+Safe.h"
#import "WKSwizzle.h"
#import "NSObject+MsgReceiver.h"
#import "WKCrashManager.h"
@interface WKTimerProxy : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, weak) NSTimer * timer;
@property (nonatomic) SEL selector;

@end

@implementation WKTimerProxy

- (void)trigger:(id)userinfo  {
    id strongTarget = self.target;
    if (strongTarget && ([strongTarget respondsToSelector:self.selector])) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:self.selector withObject:userinfo];
#pragma clang diagnostic pop
    } else {
        NSTimer *sourceTimer = self.timer;
        if (sourceTimer) {
            [sourceTimer invalidate];
        }
        WKCrashModel * model = [WKCrashModel new];
        model.clasName = NSStringFromClass([self.target class]);
        model.msg = NSStringFromSelector(self.selector);
        model.threadStack = [NSThread callStackSymbols];
        [WKCrashReport crashInfo:model type:(WKCrashType_Timer)];
    }
}

@end

@interface NSTimer ()

@property (nonatomic, strong) WKTimerProxy * timerProxy;

@end

@implementation NSTimer (Safe)

- (void)setTimerProxy:(WKTimerProxy *)timerProxy {
    objc_setAssociatedObject(self, @selector(timerProxy), timerProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WKTimerProxy *)timerProxy {
    return objc_getAssociatedObject(self, @selector(timerProxy));
}

+ (void)registerTimerCrash
{
        swizzling_exchangeMethod(objc_getClass([@"NSTimer" UTF8String]), @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:), @selector(wksafe_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
}

+ (NSTimer *)wksafe_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    if (yesOrNo) {
        WKTimerProxy * proxy = [WKTimerProxy new];
        proxy.target = aTarget;
        proxy.selector = aSelector;
        NSTimer * timer = [self wksafe_scheduledTimerWithTimeInterval:ti target:proxy selector:@selector(trigger:) userInfo:userInfo repeats:yesOrNo];
        proxy.timer = timer;
        timer.timerProxy = proxy;
        return timer;
    }
    return [self wksafe_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

@end

