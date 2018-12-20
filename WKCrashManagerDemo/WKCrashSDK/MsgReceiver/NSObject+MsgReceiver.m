//
//  NSObject+MsgReceiver.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/4.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSObject+MsgReceiver.h"

#import "WKMsgReceiver.h"
#import "WKCrashManager.h"
#import "WKSwizzle.h"
@implementation NSObject (MsgReceiver)

//直接使用原生的，后续考虑改进，但是暂不考虑


+ (void)registerUnrecognizedSelectorCrash
{
        swizzling_exchangeMethod([self class], @selector(forwardingTargetForSelector:), @selector(wk_forwardingTargetForSelector:));
        swizzling_exchangeMethod(objc_getMetaClass([NSStringFromClass([self class]) UTF8String]) , @selector(forwardingTargetForSelector:), @selector(wk_forwardingTargetForSelector:));
}


- (id)wk_forwardingTargetForSelector:(SEL)aSelector
{
    //如果当前类实现了这两个方法的任意一个 则不走桩类， 直接调用原生，主要用于防止系统类，自己实现了转发，而被我们拦截了
    if ([self canRespondForwardingMsg] || [self isInWhiteList]) {
        //如果子类实现了forwardingTargetForSelector 并且调用了super forwardingTargetForSelector也不会崩溃，这个方案 完美
        return [self wk_forwardingTargetForSelector:aSelector];
    }
    


    NSString * selName = NSStringFromSelector(aSelector);
    if ([self isKindOfClass:[NSNumber class]] && [NSString instancesRespondToSelector:aSelector]) {
        NSNumber *number = (NSNumber *)self;
        NSString *str = [number stringValue];
        return str;
    } else if ([self isKindOfClass:[NSString class]] && [NSNumber instancesRespondToSelector:aSelector]) {
        NSString *str = (NSString *)self;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [formatter numberFromString:str];
        return number;
    }
    BOOL aBool = [self respondsToSelector:aSelector];
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    if (aBool && signatrue) {
        return [self wk_forwardingTargetForSelector:aSelector];
    }
    else
    {
        [[WKMsgReceiver sharedMsgReceiver] addFunc:aSelector];
        [self sendCrashInfoWithMsg:[@"-" stringByAppendingString:selName] type:WKCrashType_UnrecognizedSelector];
        return [WKMsgReceiver sharedMsgReceiver];
    }
}

+ (id)wk_forwardingTargetForSelector:(SEL)aSelector
{
    NSString * selName = NSStringFromSelector(aSelector);
    
    BOOL aBool = [self respondsToSelector:aSelector];
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    if (aBool && signatrue) {
        return [self wk_forwardingTargetForSelector:aSelector];
    }
    else
    {
        NSLog(@"类方法出错了");
        [WKMsgReceiver addClassFunc:aSelector];
        [self sendCrashInfoWithMsg:[@"+" stringByAppendingString:selName] type:WKCrashType_UnrecognizedSelector];
        return [WKMsgReceiver class];
    }
}



- (BOOL)canRespondForwardingMsg
{

    //只要实现了forwardInvocation 表明系统类 实现了转发流程
    //forwardingTargetForSelector 不需要管的原因了，即便子类实现了forwardingTargetForSelector，但是如果出了错，还是要走nsobject的forwardingTargetForSelector，这样能够避免，子类实现了但是也调用了self或者super的方法 不会出问题
    NSArray * selectors = @[NSStringFromSelector(@selector(forwardInvocation:))];
    BOOL result = NO;
    u_int count;
    Method *methods= class_copyMethodList([self class], &count);
    for (int i = 0; i < count ; i++)
    {
        SEL name = method_getName(methods[i]);
        for (NSString * selName in selectors) {
            SEL selector = NSSelectorFromString(selName);
            if (name == selector) {//如果有任意一个 则直接yes
                result = YES;
                break;
            }
        }
        if (result) {
            break;
        }
    }
    
    if (methods != NULL)
    {
        free(methods);
        methods = NULL;
    }
    
    return result;
}

- (BOOL)isInWhiteList
{
    NSString * cn = NSStringFromClass([self class]);
    if ([[NSObject msgWhiteList] containsObject:cn]) {
        return YES;
    }
    return NO;
}

- (void)sendCrashInfoWithMsg:(NSString *)msg type:(WKCrashType)type
{
    WKCrashModel * model = [WKCrashModel new];
    model.clasName = NSStringFromClass([self class]);
    model.msg =  msg;
    model.threadStack = [NSThread callStackSymbols];
    [WKCrashReport crashInfo:model type:type];
}

+ (NSArray *)msgWhiteList
{
    static NSArray * whiteList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        whiteList = @[@"_UIBarItemAppearance",
                      @"_UIPropertyBasedAppearance",
                      @"_NSXPCDistantObjectSynchronousWithError",
                      @"_UITraitBasedAppearance",
                      @"UIWebBrowserView"];
    });
    return whiteList;
}

@end

