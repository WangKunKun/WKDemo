//
//  WKRestoreSceneManager.m
//  KanManHua
//
//  Created by wangkun on 2017/11/14.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import "WKRestoreSceneManager.h"
#import "WKClassManager.h"
#import "AppDelegate+visableVC.h"
#import <objc/message.h>
#import "UIViewController+RestoreScene.h"
@interface WKRestoreSceneManager ()

@end

@implementation WKRestoreSceneManager

+ (instancetype)sharedRestoreSceneManager
{
    static WKRestoreSceneManager * rsm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rsm = [WKRestoreSceneManager new];
    });
    return rsm;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminateNotification:) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)willResignActive:(NSNotification *)noti
{

    NSString *dicPath = [self getRestoreFilePath];
    UIViewController * vc = [AppDelegate getVisableVC];
    Class cls = [vc class];
    if([cls respondsToSelector:@selector(restoreSceneKey)])
    {
        NSMutableDictionary * mutableDict = [NSMutableDictionary dictionary];
        [mutableDict setObject:NSStringFromClass(cls) forKey:@"ClassName"];
        NSArray * keyArr = [cls restoreSceneKey];
        for (NSString * key in keyArr) {
            id value = [vc valueForKeyPath:key];//kvc
            if (value) {
                [mutableDict setObject:value forKey:key];
            }
        }
        [mutableDict writeToFile:dicPath atomically:YES];
    }
    else
    {
        [self clearRestoreFile];
    }
}

-(void)didBecomeActive:(NSNotification *)noti
{
    NSString * dicPath = [self getRestoreFilePath];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:dicPath];
    if (bRet) {
        //需要恢复场景
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:dicPath];
        if (!dict) {
            return;
        }
        NSString * className = [dict objectForKey:@"ClassName"];
        if (!className) {
            return;
        }
        UIViewController * visiableVC = [AppDelegate getVisableVC];

        
        Class class = NSClassFromString(className);

        if (class ) {
            [dict removeObjectForKey:@"ClassName"];
            //健壮性检测，保证数据不被恶意修改
            if ([class respondsToSelector:@selector(restoreSceneKey)]) {
                NSArray * keys = [class restoreSceneKey];
                for (NSString * key in keys) {
                    if ([dict objectForKey:key] == nil)
                    {
                        [self clearRestoreFile];
                        return;
                    }
                }
            }
            //同一个vc  数据相同 不弹出
            if ([className isEqualToString:NSStringFromClass([visiableVC class])]) {
                NSArray * keys = [class restoreSceneKey];
                BOOL isAllEqual = YES;
                for (NSString * key in keys) {
                    if (![[dict valueForKey:key] isEqual:[visiableVC valueForKey:key]]) {
                        isAllEqual = NO;
                    }
                }
                if (isAllEqual) {
                    return;
                }
            }
            id object = [[class alloc] init];
            NSArray * propertyNames = [dict allKeys];
            NSMutableArray * propertys = [NSMutableArray array];
            for (NSString * propertyName in propertyNames) {
                const char * pn = [propertyName UTF8String];
                objc_property_t pt = class_getProperty(class, pn);
                if (pt != NULL) {
                    WKClassPropertyModel * model = [WKClassPropertyModel createClassPropertyModelWithProperty:pt];
                    [propertys addObject:model];
                }
            }
            for (WKClassPropertyModel * propertyModel in propertys) {
                for (NSString * propertyName in propertyNames) {
                    if ([propertyModel.name isEqualToString:propertyName])
                    {
                        switch (propertyModel.type) {
                            case WKPropertyType_Object:
                                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, NSSelectorFromString(propertyModel.setterName), [dict objectForKey:propertyName]);
                                break;
                            case WKPropertyType_CNumber:
                                ((void (*)(id, SEL, long long))(void *) objc_msgSend)((id)object, NSSelectorFromString(propertyModel.setterName), [[dict objectForKey:propertyName] longLongValue]);
                            default:
                                break;
                        }
                    }
                }
            }
            if (visiableVC.navigationController) {
                [visiableVC.navigationController pushViewController:object animated:YES];
            }
        }
        [self clearRestoreFile];

    }
}

- (void)willTerminateNotification:(NSNotification *)noti
{
    [self clearRestoreFile];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)clearRestoreFile
{
    NSString * dicPath = [self getRestoreFilePath];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:dicPath];
    if (bRet) {
        //删除文件内容
        NSMutableDictionary * mutableDict = [NSMutableDictionary dictionary];
        [mutableDict writeToFile:dicPath atomically:YES];

    }
    return YES;
}

- (NSString *)getRestoreFilePath
{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath= paths.firstObject;
    NSString *dicPath = [documentsPath stringByAppendingPathComponent:@"wk_restoreScene"];
    return dicPath;
}

@end
