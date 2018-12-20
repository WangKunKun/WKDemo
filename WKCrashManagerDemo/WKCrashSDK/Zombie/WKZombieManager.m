//
//  WKZombieManager.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/9.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "WKZombieManager.h"
#import "WKMsgReceiver.h"
#import "WKSwizzle.h"
#import "NSObject+WKZombie.h"
#import "NSObject+MsgReceiver.h"
@implementation WKZombieStub

- (instancetype)init{
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    
    [self sendCrashInfoWithMsg:[NSString stringWithFormat:@"- %@",NSStringFromSelector(aSelector)] type:(WKCrashType_Zombie)];
    WKMsgReceiver *stub = [WKMsgReceiver sharedMsgReceiver];
    [stub addFunc:aSelector];
    return [[WKMsgReceiver class] instanceMethodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:[WKMsgReceiver sharedMsgReceiver]];
}

@end

@implementation WKZombieManager

+ (instancetype)sharedZombieManager
{
    static WKZombieManager * zm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zm = [WKZombieManager new];
    });
    return zm;
}

- (NSMutableArray *)zombieClassArr
{
    if (!_zombieClassArr) {
        _zombieClassArr = [NSMutableArray array];
    }
    return _zombieClassArr;
}


+ (void)registerZombieCrashWithClassArr:(NSArray *)classArr
{
    WKZombieManager * zm = [WKZombieManager sharedZombieManager];
    NSMutableArray * realArr = [NSMutableArray arrayWithArray:classArr];
    for (NSString * className in classArr) {
        NSBundle * bundle = [NSBundle bundleForClass:NSClassFromString(className)];
        if (bundle != [NSBundle mainBundle]) {
            [realArr removeObject:className];
        }
    }
    zm.zombieClassArr = realArr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([NSObject class], NSSelectorFromString(@"dealloc"), @selector(wkzombiesafe_dealloc));
    });
}


@end
