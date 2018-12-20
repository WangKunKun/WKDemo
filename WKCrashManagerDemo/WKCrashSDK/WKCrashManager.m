//
//  WKCrashManager.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/8.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "WKCrashManager.h"
#import "WKZombieManager.h"

#import "NSArray+Safe.h"
#import "NSMutableArray+Safe.h"
#import "NSMutableArray+SafeObjectAtIndex.h"
#import "NSDictionary+Safe.h"
#import "NSMutableDictionary+Safe.h"

#import "NSSet+Safe.h"
#import "NSMutableSet+Safe.h"

#import "NSString+Safe.h"
#import "NSMutableString+Safe.h"

#import "NSObject+SafeKVO.h"

#import "NSObject+MsgReceiver.h"

#import "NSNull+Safe.h"

#import "NSTimer+Safe.h"

#import "NSNotificationCenter+Safe.h"

#import "WKCrashReport.h"

@interface WKCrashManager ()<WKCrashReportDelegate>

@property (nonatomic) WKCrashRegisterType type;

@end

@implementation WKCrashManager

+ (instancetype)sharedCrashManager
{
    static WKCrashManager * cm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cm = [WKCrashManager new];
        [WKCrashReport sharedReport].delegate = cm;
    });
    return cm;
}


- (void)handleCrashInfo:(WKCrashModel *)model type:(NSString *)type
{
    ///TODO:数据上传处理
}

+ (void)regeisterCrashSDKWithType:(WKCrashRegisterType)type
{
    
    WKCrashManager * cm = [self sharedCrashManager];
    if (type == cm.type) {
        return;
    }
    
    if (type == WKCrashRegisterType_None) {
        //等于none时，表明之前注册过的需要全部 取消注册，第二次注册则可以取消
        [self registerWithType:cm.type];
    }
    else if (cm.type == WKCrashRegisterType_None)
    {
        [self registerWithType:type];
    }
    else
    {
        //异或 实现 取消注册部分的功能
        [self registerWithType:cm.type ^ type];
    }
    cm.type = type;
}

+ (void)registerWithType:(WKCrashRegisterType)type
{
    if (type & WKCrashRegisterType_UnrecognizedSelector) {
        [NSObject registerUnrecognizedSelectorCrash];
    }
    if (type & WKCrashRegisterType_KVO) {
        [NSObject registerKVOCrash];
    }
    if (type & WKCrashRegisterType_NotificationCenter) {
        [NSNotificationCenter registerNotificationCenterCrash];
    }
    if (type & WKCrashRegisterType_Container) {
        [NSArray registerArrayCrash];
        [NSMutableArray registerMutableArrayCrash];
        [NSMutableArray registerMutableArrayObjectAtIndex];
        [NSDictionary registerDictonaryCrash];
        [NSMutableDictionary registerMutableDictionaryCrash];
        [NSMutableSet registerMutableSetCrash];
//        [NSCache registerCacheCrash];
    }
    if (type & WKCrashType_String) {
        [NSString registerStringCrash];
        [NSMutableString registerMutableStringCrash];
    }
    if (type & WKCrashRegisterType_Null) {
        [NSNull registerNullCrash];
    }
    if (type & WKCrashRegisterType_Timer) {
        [NSTimer registerTimerCrash];
    }
}

+ (void)regeisterZombieCrashWithClasses:(NSArray *)classes
{
    [WKZombieManager registerZombieCrashWithClassArr:classes];
}

@end

__attribute__((constructor)) static void constInit(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            //TODO 默认除僵尸检测外 全部开启 如需和线上配合 需和后台定义接口字段等等。只需要再次调用同样注册方法，即可实现开启 关闭
            [WKCrashManager regeisterCrashSDKWithType:(WKCrashRegisterType_All)];
//            [WKCrashManager regeisterZombieCrashWithClasses:@[]];

        }
    });
}


