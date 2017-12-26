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


@interface NSObject (DataBase)
@property (nonatomic, assign) NSTimeInterval  saveiIntervaltime;
@property (nonatomic, strong, readonly) NSMutableDictionary * saveKeyValue;

+ (void)wk_exchangeSetter;
//数据库主key  主键不能被忽略
+ (NSArray *)DBMainKey;
//数据库需要忽略存储的属性(不写入表) 主键不能被忽略
+ (NSArray *)ignoreProperty;

//主键是否可为空  特殊情形，一个模型对应多种情况，每一种情况对应主键不同，但是写表需要全部写入，因为在一个模型里，设计问题
//默认NO
+ (BOOL)DBMainKeyCanBeEmpty;

//调用FMDB 可重写
- (void)saveToLocal;

@end
