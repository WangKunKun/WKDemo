//
//  WKClassMethodModel.m
//  exchangeSetter
//
//  Created by wangkun on 2017/11/9.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "WKClassMethodModel.h"

@implementation WKClassMethodModel

+ (instancetype)createClassMethodModelWithMethod:(Method)method
{
    WKClassMethodModel * model = [self new];
    model.name = NSStringFromSelector(method_getName(method));
    model.oldIMP = method_getImplementation(method);
    model.method = method;
    return model;
}

@end
