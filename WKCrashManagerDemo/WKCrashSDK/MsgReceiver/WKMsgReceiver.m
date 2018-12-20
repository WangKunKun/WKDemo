//
//  WKMsgReceiver.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/4.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "WKMsgReceiver.h"
#import <objc/runtime.h>


int commonFunc(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethod(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    //有多少个冒号 就证明有多少个入参
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    //因为后续的参数 未使用，所以不在意对面参数 传入的是什么 返回值改为int 以及 参数改为id
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)commonFunc, funcTypeEncoding);
}

@implementation WKMsgReceiver

+ (instancetype)sharedMsgReceiver
{
    static WKMsgReceiver * msgR = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgR = [WKMsgReceiver new];
    });
    return msgR;
}

- (BOOL)addFunc:(SEL)sel
{
    return __addMethod([self class], sel);
}

+ (BOOL)addClassFunc:(SEL)sel {
    Class metaClass = objc_getMetaClass(class_getName([self class]));
    return __addMethod(metaClass, sel);
}
@end
