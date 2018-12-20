//
//  NSObject+Zombie.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/9.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSObject+WKZombie.h"
#import <list>
#import <objc/runtime.h>
#import "WKZombieManager.h"

static NSInteger const maxCount = 100;
static std::list<id> instanceList;

@implementation NSObject (WKZombie)

- (void)wkzombiesafe_dealloc
{
    
    NSArray * classArr = [WKZombieManager sharedZombieManager].zombieClassArr;
    Class selfClass = object_getClass(self);
    BOOL needProtect = NO;
    for (NSString *className in classArr) {
        Class clazz = objc_getClass([className UTF8String]);
        if (clazz == selfClass) {
            needProtect = YES;
            break;
        }
    }
    [classArr release];
    if (needProtect) {
        NSString *className = NSStringFromClass(selfClass);
        NSString *zombieClassName = [@"WKZombie_" stringByAppendingString: className];//这一步很重要，动态生成类，如果被僵尸，则可以得知实际是哪个类产生了僵尸指针 导致崩溃
        Class zombieClass = NSClassFromString(zombieClassName);
        if(!zombieClass) {
            zombieClass = objc_allocateClassPair([WKZombieStub class], [zombieClassName UTF8String], 0);
        }
        objc_destructInstance(self);//销毁实例 相关信息 内存不释放
        object_setClass(self, zombieClass);
        instanceList.size();
        if (instanceList.size() >= maxCount) {
            id object = instanceList.front();
            instanceList.pop_front();
            free(object);
        }
        instanceList.push_back(self);
    }
    else
    {
        [self wkzombiesafe_dealloc];
    }

}

@end
