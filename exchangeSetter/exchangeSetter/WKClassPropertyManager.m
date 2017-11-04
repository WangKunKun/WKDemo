//
//  WKClassPropertyManager.m
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "WKClassPropertyManager.h"
#import "WKClassPropertyModel.h"
#import <objc/runtime.h>

@interface WKClassPropertyManager ()

@property (nonatomic, strong) NSCache * cache;

@end

@implementation WKClassPropertyManager

+ (instancetype)sharedManager
{
    static WKClassPropertyManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WKClassPropertyManager new];
    });
    return manager;
}

+ (NSArray <WKClassPropertyModel *> *)getClassPropertysWithClass:(Class)classs
{
    
    WKClassPropertyManager * manager = [self sharedManager];
    NSString * key = NSStringFromClass(classs);
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
