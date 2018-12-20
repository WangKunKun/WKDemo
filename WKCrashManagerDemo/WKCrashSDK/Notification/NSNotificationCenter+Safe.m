//
//  NSNotificationCenter+Safe.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/7.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSNotificationCenter+Safe.h"
#import "WKSwizzle.h"
#import "WKCrashManager.h"
@interface WKNotifiProxy : NSObject


@end

@implementation WKNotifiProxy{
    __strong NSMutableArray *_centers;
    __unsafe_unretained id _obs;
}

- (instancetype)initWithObserver:(id)obs {
    if (self = [super init]) {
        _obs = obs;
        _centers = @[].mutableCopy;
    }
    return self;
}

- (void)addCenter:(NSNotificationCenter*)center {
    if (center) {
        [_centers addObject:center];
    }
}

- (void)dealloc {
    @autoreleasepool {
        for (NSNotificationCenter *center in _centers) {
            [center removeObserver:_obs];
        }
    }
}
@end


@implementation NSNotificationCenter (Safe)

+ (void)registerNotificationCenterCrash
{
        swizzling_exchangeMethod([self class], @selector(addObserver:selector:name:object:), @selector(wksafe_addObserver:selector:name:object:));
}

- (void)wksafe_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject
{
    [self wksafe_addObserver:observer selector:aSelector name:aName object:anObject];
    addCenterForObserver(self, observer);
}


void addCenterForObserver(NSNotificationCenter *center ,id obs) {
    WKNotifiProxy *remover = nil;
    static char removerKey;
    @autoreleasepool {
        remover = objc_getAssociatedObject(obs, &removerKey);
        if (!remover) {
            remover = [[WKNotifiProxy alloc] initWithObserver:obs];
            objc_setAssociatedObject(obs, &removerKey, remover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [remover addCenter:center];
    }
}

@end
