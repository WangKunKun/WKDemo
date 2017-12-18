//
//  NSObject+DataBase.h
//  exchangeSetter
//
//  Created by wangkun on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+DealBlock.h"

#define WKDataBaseSetter \
+ (void)load \
{ \
    [self wk_exchangeSetter]; \
} \




//新建表
//删除表

@interface NSObject (DataBase)
@property (nonatomic, assign) NSTimeInterval  saveiIntervaltime;
@property (nonatomic, strong, readonly) NSMutableDictionary * saveKeyValue;


+ (void)wk_exchangeSetter;
//数据库主key
+ (NSArray *)DBMainKey;

- (void)saveToLocal;//未实现 根据具体需求实现 更新表

@end
