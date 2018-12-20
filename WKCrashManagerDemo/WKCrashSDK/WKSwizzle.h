//
//  WKSwizzle.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/5.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#include <objc/runtime.h>


static inline void swizzling_exchangeMethod(Class clazz, SEL originalSelector, SEL exchangeSelector) {
    
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    
    Method exchangeMethod = class_getInstanceMethod(clazz, exchangeSelector);
    if (class_addMethod(clazz, originalSelector, method_getImplementation(exchangeMethod), method_getTypeEncoding(exchangeMethod))) {
        class_replaceMethod(clazz, exchangeSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, exchangeMethod);
    }
}

