//
//  NSString+Safe.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/7.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSString+Safe.h"
#import "WKSwizzle.h"
#import "NSObject+MsgReceiver.h"
#import "WKCrashManager.h"
@implementation NSString (Safe)

+ (void)registerStringCrash
{
    
        //类方法
        swizzling_exchangeMethod(object_getClass([self class]), @selector(stringWithUTF8String:), @selector(wksafe_stringWithUTF8String:));
        swizzling_exchangeMethod(object_getClass([self class]), @selector(stringWithCString:encoding:), @selector(wksafe_stringWithCString:encoding:));
        //alloc 实例方法
        swizzling_exchangeMethod(NSClassFromString(@"NSPlaceholderString"), @selector(initWithCString:encoding:), @selector(wksafe_initWithCString:encoding:));
        swizzling_exchangeMethod(NSClassFromString(@"NSPlaceholderString"), @selector(initWithString:), @selector(wksafe_initWithString:));
        
        //实例方法
        swizzling_exchangeMethod([self class], @selector(initWithUTF8String:), @selector(wksafe_initWithUTF8String:));
        swizzling_exchangeMethod([self class], @selector(stringByAppendingString:), @selector(wksafe_stringByAppendingString:));
        swizzling_exchangeMethod([self class], @selector(substringFromIndex:), @selector(wksafe_substringFromIndex:));
        swizzling_exchangeMethod([self class], @selector(substringToIndex:), @selector(wksafe_substringToIndex:));
        swizzling_exchangeMethod([self class], @selector(substringWithRange:), @selector(wksafe_substringWithRange:));




}

+ (instancetype)wksafe_stringWithUTF8String:(const char *)nullTerminatedCString
{
    if (NULL != nullTerminatedCString) {
        return [self wksafe_stringWithUTF8String:nullTerminatedCString];
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
    return nil;
}

+ (instancetype)wksafe_stringWithCString:(const char *)cString encoding:(NSStringEncoding)enc
{
    if (NULL != cString) {
        return [self wksafe_stringWithCString:cString encoding:enc];
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
    return nil;
}


- (instancetype)wksafe_initWithUTF8String:(const char *)nullTerminatedCString
{
    if (NULL != nullTerminatedCString) {
        return [self wksafe_initWithUTF8String:nullTerminatedCString];
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
    return nil;
}

- (instancetype)wksafe_initWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding
{
    if (NULL != nullTerminatedCString) {
        return [self wksafe_initWithCString:nullTerminatedCString encoding:encoding];
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
    return nil;
}

- (NSString *)wksafe_substringFromIndex:(NSUInteger)from
{
    if (from <= self.length) {
        return [self wksafe_substringFromIndex:from];
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
    return nil;
}

- (NSString *)wksafe_substringToIndex:(NSUInteger)to
{
    if (to > self.length) {
        [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
        to = self.length;
    }
    return [self wksafe_substringToIndex:to];

}

- (NSString *)wksafe_substringWithRange:(NSRange)range
{
    if (range.location + range.length <= self.length) {
        return [self wksafe_substringWithRange:range];
    }else if (range.location < self.length){
        return [self wksafe_substringWithRange:NSMakeRange(range.location, self.length-range.location)];
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
    return nil;
}

- (NSString *)wksafe_stringByAppendingString:(NSString *)aString
{
    if (aString) {
        return [self wksafe_stringByAppendingString:aString];
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
    return [NSString stringWithString:self];
}

- (instancetype)wksafe_initWithString:(NSString *)aString
{
    if (aString) {
        return [self wksafe_initWithString:aString];
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
    return nil;
}
@end


