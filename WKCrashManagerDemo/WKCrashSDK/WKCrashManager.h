//
//  WKCrashManager.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/8.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>




typedef NS_OPTIONS(NSUInteger, WKCrashRegisterType) {
    WKCrashRegisterType_None = 0,
    WKCrashRegisterType_UnrecognizedSelector = 1 << 1,
    WKCrashRegisterType_Container = 1 << 2,
    WKCrashRegisterType_Timer = 1 << 3,
    WKCrashRegisterType_KVO = 1 << 4,
    WKCrashRegisterType_Null = 1 << 5,
    WKCrashRegisterType_String = 1 << 6,
    WKCrashRegisterType_Zombie = 1 << 7,
    WKCrashRegisterType_NotificationCenter = 1 << 8,
    WKCrashRegisterType_All = (WKCrashRegisterType_UnrecognizedSelector |
                               WKCrashRegisterType_Container |
                               WKCrashRegisterType_Timer |
                               WKCrashRegisterType_KVO |
                               WKCrashRegisterType_Null |
                               WKCrashRegisterType_String |
                               WKCrashRegisterType_NotificationCenter)
};


@interface WKCrashManager : NSObject

+ (instancetype)sharedCrashManager;
+ (void)regeisterCrashSDKWithType:(WKCrashRegisterType)type;//注册非僵尸crash
+ (void)regeisterZombieCrashWithClasses:(NSArray *)classes;//注册僵尸crash 需要传入数组
@end
