//
//  NSObject+MsgReceiver.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/4.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKCrashReport.h"

@interface NSObject (MsgReceiver)

- (void)sendCrashInfoWithMsg:(NSString *)msg type:(WKCrashType)type;
+ (void)registerUnrecognizedSelectorCrash;
@end
