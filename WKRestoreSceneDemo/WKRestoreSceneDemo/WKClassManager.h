//
//  WKClassPropertyManager.h
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKClassPropertyModel.h"
#import "WKClassMethodModel.h"
@interface WKClassManager : NSObject

+ (NSArray <WKClassPropertyModel *> *)getClassPropertysWithClass:(Class)classs;
+ (NSArray <WKClassMethodModel *> *)getClassMethodsWithClass:(Class)classs;

@end
