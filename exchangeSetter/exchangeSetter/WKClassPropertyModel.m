//
//  WKClassPropertyModel.m
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "WKClassPropertyModel.h"

@implementation WKClassPropertyModel

+ (instancetype)createClassPropertyModelWithProperty:(objc_property_t)property
{
    WKClassPropertyModel * model = [self new];
    model.name = [NSString stringWithUTF8String:property_getName(property)];
    NSString * attrStr = [NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:property_getAttributes(property)]];
    NSArray * attrs = [attrStr componentsSeparatedByString:@","];
    
    for (NSString * str in attrs) {
        if([str hasPrefix:@"T"])//类型
        {
            model.type = [str substringFromIndex:1];
        }
        if([str hasPrefix:@"S"])//自定义setter
        {
            model.setterName = [str substringFromIndex:1];
        }
        if([str hasPrefix:@"G"])//自定义getter
        {
            model.getterName = [str substringFromIndex:1];
        }
        if([str hasPrefix:@"V"])//属性转换的变量名
        {
            model.varName = [str substringFromIndex:1];
        }
    }
    
    if (!model.setterName) {
        
        NSString * header =  [[model.name substringToIndex:1] uppercaseString];
        NSString * footer = [model.name substringFromIndex:1];
        model.setterName = [NSString stringWithFormat:@"set%@%@:",header,footer];
    }
    
    if (!model.getterName) {
        model.getterName = model.name;
    }
    
    return model;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@\nvarname = %@, type=%@\ngetter = %@, setter = %@\n",self.name,self.varName,self.type,self.getterName,self.setterName];
}

@end
