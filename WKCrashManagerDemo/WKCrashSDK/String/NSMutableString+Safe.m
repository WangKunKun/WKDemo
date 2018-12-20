//
//  NSMutableString+Safe.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/7.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSMutableString+Safe.h"
#import "WKSwizzle.h"
#import "NSObject+MsgReceiver.h"
#import "WKCrashManager.h"
@implementation NSMutableString (Safe)

+ (void)registerMutableStringCrash
{
        swizzling_exchangeMethod(NSClassFromString(@"__NSCFString"), @selector(appendString:), @selector(wksafe_appendString:));
        swizzling_exchangeMethod(NSClassFromString(@"__NSCFString"), @selector(insertString:atIndex:), @selector(wksafe_insertString:atIndex:));
}

- (void)wksafe_appendString:(NSString *)aString
{
    if (aString) {
        [self wksafe_appendString:aString];
        return;
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];
}

- (void)wksafe_insertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    if (aString && loc <= self.length) {
        [self wksafe_insertString:aString atIndex:loc];
        return;
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_String)];

}
@end

