//
//  WKCrashReport.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/4.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WKCrashType_UnrecognizedSelector = 0,
    WKCrashType_Container,
    WKCrashType_Timer,
    WKCrashType_KVO,
    WKCrashType_Null,
    WKCrashType_String,
    WKCrashType_Zombie,
    WKCrashType_NotificationCenter,
} WKCrashType;

//不同的crash 信息当有不同的侧重点，主要是类名，方法名，由于什么原因崩溃，对战信息
@interface WKCrashModel : NSObject

@property (nonatomic, strong) NSString * clasName;
@property (nonatomic, strong) NSString * msg;//could be 方法名，或者其他
@property (nonatomic, strong) NSArray  * threadStack;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, strong, readonly) NSString * deviceType;
@property (nonatomic, strong, readonly) NSString * systemVersion;

@end
@protocol WKCrashReportDelegate <NSObject>

- (void)handleCrashInfo:(WKCrashModel *)model type:(NSString *)type;

@end

@interface WKCrashReport : NSObject

@property (nonatomic, weak ) id<WKCrashReportDelegate> delegate;

+ (instancetype)sharedReport;

+ (void)crashInfo:(WKCrashModel *)model type:(WKCrashType)type;
+ (NSDictionary *)getCrashReportWithType:(WKCrashType)type;
+ (NSArray *)getAllCrashReport;
+ (NSString *)getPathKeyWithType:(WKCrashType)type;
+ (void)setWarnningTextWithType:(WKCrashType)type;
+ (NSArray *)decodeWithString:(NSString *)str;

@end
