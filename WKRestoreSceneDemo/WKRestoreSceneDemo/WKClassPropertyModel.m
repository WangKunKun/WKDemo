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
            model.typeName = [model getTypeNameWithStr:str];
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

- (NSString *)getTypeNameWithStr:(NSString * )str
{
    NSString * typeName = str;
    if ([typeName containsString:@"@"]) {
        typeName = [typeName substringFromIndex:2];
        typeName = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        self.type = WKPropertyType_Object;
    }else{
        self.type = WKPropertyType_CNumber;
        typeName = [typeName substringFromIndex:1];
        const char * rawPropertyType = [typeName UTF8String];
        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            typeName = @"float";
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            typeName = @"int";
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            typeName = @"id";
        } else if (strcmp(rawPropertyType, @encode(double)) == 0){
            typeName = @"double";
        }else if(strcmp(rawPropertyType, @encode(long)) == 0){
            typeName = @"long";
        }else if(strcmp(rawPropertyType, @encode(unsigned int)) == 0){
            typeName = @"NSUInteger";
        }else if(strcmp(rawPropertyType, @encode(unsigned long)) == 0){
            typeName = @"NSUInteger";
        }
        else if(strcmp(rawPropertyType, @encode(BOOL)) == 0){
            typeName = @"BOOL";
        }
        else
        {
            self.type = WKPropertyType_Unknown;
        }
    }
    return typeName;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@\nvarname = %@, type=%@\ngetter = %@, setter = %@\n",self.name,self.varName,self.type,self.getterName,self.setterName];
}

@end
