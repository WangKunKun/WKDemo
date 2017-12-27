//
//  WKClassPropertyManager.m
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "WKClassManager.h"
#import "WKClassPropertyModel.h"
#import <objc/runtime.h>

#define PROPERTYKEY @"PropertyKey"
#define METHODKEY @"MethodKey"

@interface WKClassManager ()

@property (nonatomic, strong) NSCache * cache;

@end

@implementation WKClassManager

+ (instancetype)sharedManager
{
    static WKClassManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WKClassManager new];
    });
    return manager;
}

+ (NSArray <WKClassPropertyModel *> *)getClassPropertysWithClass:(Class)classs
{
    WKClassManager * manager = [self sharedManager];
    NSString * key = [NSString stringWithFormat:@"%@ + %@",NSStringFromClass(classs),PROPERTYKEY] ;
    NSMutableArray * models = [manager.cache objectForKey:key];
    if (models) {
        return models;
    }
    models = [NSMutableArray array];
    unsigned int count = 0;
    //获得属性列表
    objc_property_t * propertys = class_copyPropertyList(classs, &count);
    //遍历属性列表
    for (unsigned int i = 0; i < count; i ++) {
        WKClassPropertyModel * model = [WKClassPropertyModel createClassPropertyModelWithProperty:propertys[i]];
        [models addObject:model];
    }
    
    
    NSArray * methods = [self getClassMethodsWithClass:classs];
    for (WKClassMethodModel * methodModel in methods) {
        for (WKClassPropertyModel * model in models) {
            if([model.setterName isEqualToString:methodModel.name])
            {
                model.oldsetterIMP = methodModel.oldIMP;
            }
        }
    }
    [manager.cache setObject:models forKey:key];
    
    return models;
}

+ (NSArray <WKClassMethodModel *> *)getClassMethodsWithClass:(Class)classs
{
    WKClassManager * manager = [self sharedManager];
    NSString * key = [NSString stringWithFormat:@"%@ + %@",NSStringFromClass(classs),METHODKEY] ;
    NSMutableArray * models = [manager.cache objectForKey:key];
    if (models) {
        return models;
    }
    models = [NSMutableArray array];
    unsigned int count = 0;
    //获得属性列表
    Method * methods = class_copyMethodList(classs, &count);
    //遍历属性列表
    for (unsigned int i = 0; i < count; i ++) {
        WKClassMethodModel * model = [WKClassMethodModel createClassMethodModelWithMethod:methods[i]];
        [models addObject:model];
    }
    
    [manager.cache setObject:models forKey:key];
    
    return models;
}

- (NSCache *)cache
{
    if (!_cache) {
        _cache = [NSCache new];
    }
    return _cache;
}

@end
