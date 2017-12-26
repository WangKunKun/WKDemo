//
//  WKSearchStringManager.h
//  MKWeekly
//
//  Created by wangkun on 2017/12/26.
//  Copyright © 2017年 zymk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKSearchStringManager : NSObject
+ (instancetype)sharedSearchStringManager;
@property (nonatomic, copy) NSString * searchStr;
@property (nonatomic, copy) NSString * sourceStr;
- (NSMutableArray <NSValue *> *)matching;
@end
