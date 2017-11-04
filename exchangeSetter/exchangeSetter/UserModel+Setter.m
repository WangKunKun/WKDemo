//
//  UserModel+Setter.m
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "UserModel+Setter.h"
#import <objc/runtime.h>
#import "WKClassPropertyManager.h"
static void new_setter_object(id self, SEL _cmd, id newValue)
{
    
    NSArray <WKClassPropertyModel *> * arr = [WKClassPropertyManager getClassPropertysWithClass:[self class]];
    
    
    NSString * setter = NSStringFromSelector(_cmd);
    
    
    WKClassPropertyModel * selectedModel = nil;
    for (WKClassPropertyModel * model in arr) {
        if([model.setterName isEqualToString:setter])
        {
            selectedModel = model;
            break;
        }
    }
    
    if (!selectedModel) {
        return ;
    }

    
    //拼接变量名
    NSString * varName = selectedModel.varName;
    
    unsigned int count = 0;
    //得到变量列表
    Ivar * members = class_copyIvarList([self class], &count);
    
    int index = -1;
    //遍历变量
    for (int i = 0 ; i < count; i++) {
        Ivar var = members[i];
        //获得变量名
        const char *memberName = ivar_getName(var);
        
        //生成string
        NSString * memberNameStr = [NSString stringWithUTF8String:memberName];
        if ([varName isEqualToString:memberNameStr]) {
            index = i;
            break ;
        }
        
    }
    
    //变量存在则赋值
    if (index > -1) {
        Ivar member= members[index];
        object_setIvar(self, member, newValue);
        NSLog(@"修改成功");
    }
}

static void new_setter_long(id self, SEL _cmd, long long newValue)
{
    
    NSArray <WKClassPropertyModel *> * arr = [WKClassPropertyManager getClassPropertysWithClass:[self class]];
    
    
    NSString * setter = NSStringFromSelector(_cmd);
    
    
    WKClassPropertyModel * selectedModel = nil;
    for (WKClassPropertyModel * model in arr) {
        if([model.setterName isEqualToString:setter])
        {
            selectedModel = model;
            break;
        }
    }
    
    if (!selectedModel) {
        return ;
    }
    
    
    //拼接变量名
    NSString * varName = selectedModel.varName;
    
    unsigned int count = 0;
    //得到变量列表
    Ivar * members = class_copyIvarList([self class], &count);
    
    int index = -1;
    //遍历变量
    for (int i = 0 ; i < count; i++) {
        Ivar var = members[i];
        //获得变量名
        const char *memberName = ivar_getName(var);
        
        //生成string
        NSString * memberNameStr = [NSString stringWithUTF8String:memberName];
        if ([varName isEqualToString:memberNameStr]) {
            index = i;
            break ;
        }
        
    }
    
    //变量存在则赋值
    if (index > -1) {
        Ivar member= members[index];
        object_setIvar(self,member,(__bridge id)((void*)newValue));
        NSLog(@"修改成功");
    }
}

@implementation UserModel (Setter)

+ (void)load{
    
    unsigned int count = 0;
    
    NSArray <WKClassPropertyModel *> * arr = [WKClassPropertyManager getClassPropertysWithClass:[self class]];
    //获得方法列表
    Method * a = class_copyMethodList([self class], &count);
    //遍历方法列表
    for (unsigned int i = 0; i < count; i ++) {
        
        NSString * methodName = NSStringFromSelector(method_getName(a[i]));
        
        for (WKClassPropertyModel * model in arr) {
            if ([model.setterName isEqualToString:methodName]) {
                if ([model.type containsString:@"@"])
                {
                    method_setImplementation(a[i], (IMP)new_setter_object);
                }
                else
                {
                    method_setImplementation(a[i], (IMP)new_setter_long);
                }
            }
        }

    }
    
}



@end
