//
//  NSMutableArray+SafeObjectAtIndex.m
//  MKWeekly
//
//  Created by wangkun on 2018/7/28.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "NSMutableArray+SafeObjectAtIndex.h"
#import "WKSwizzle.h"
#import "WKCrashManager.h"
#import "NSObject+MsgReceiver.h"

@implementation NSMutableArray (SafeObjectAtIndex)

+ (void)registerMutableArrayObjectAtIndex
{
    swizzling_exchangeMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:), @selector(arrayM_objectAtIndex:));

}

- (id)arrayM_objectAtIndex:(NSUInteger)index{
    //思考会不会有内存泄漏 mrc 下
    @autoreleasepool {
        if(index < self.count){
            return [self arrayM_objectAtIndex:index];
        }
        [self sendCrashInfoWithMsg:[NSString stringWithUTF8String:__func__] type:(WKCrashType_Container)];
        return nil;
    }
}



@end
