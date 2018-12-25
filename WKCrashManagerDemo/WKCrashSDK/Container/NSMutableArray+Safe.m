//
//  NSMutableArray+Safe.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/5.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "NSArray+Safe.h"
#import "WKSwizzle.h"
#import "WKCrashManager.h"
#import "NSObject+MsgReceiver.h"

@implementation NSMutableArray (Safe)

+ (void)registerMutableArrayCrash
{
        swizzling_exchangeMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndexedSubscript:), @selector(arrayM_objectAtIndexedSubscript:));
        swizzling_exchangeMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:), @selector(arrayM_addObject:));
        swizzling_exchangeMethod(NSClassFromString(@"__NSArrayM"), @selector(insertObject:atIndex:), @selector(arrayM_insertObject:atIndex:));
        swizzling_exchangeMethod(NSClassFromString(@"__NSArrayM"), @selector(setObject:atIndexedSubscript:), @selector(arrayM_setObject:atIndexedSubscript:));
        swizzling_exchangeMethod(NSClassFromString(@"__NSArrayM"), @selector(removeObjectAtIndex:), @selector(arrayM_removeObjectAtIndex:));

}



- (id)arrayM_objectAtIndexedSubscript:(NSUInteger)index{
    if(index < self.count){
        return [self arrayM_objectAtIndexedSubscript:index];
    }
    [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
    return nil;
}

- (void)arrayM_addObject:(id)anObject
{
    if (anObject) {
        [self arrayM_addObject:anObject];
    }
    else
    {
        [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
    }
}

- (void)arrayM_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    //小于等于 必须
    if (anObject && index <= self.count) {
        [self arrayM_insertObject:anObject atIndex:index];
    }
    else
    {
        [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
    }
}

- (void)arrayM_removeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        [self arrayM_removeObjectAtIndex:index];
    }
    else
    {
        [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
    }
}

- (void)arrayM_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    if (idx <= self.count && obj) {
        [self arrayM_setObject:obj atIndexedSubscript:idx];
    }
    else
    {
        [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
    }
}

@end

