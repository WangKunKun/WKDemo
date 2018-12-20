//
//  NSMutableString+Safe.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/7.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Safe)

+ (void)registerMutableStringCrash;

@end
