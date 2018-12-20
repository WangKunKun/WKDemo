//
//  NSMutableArray+Safe.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/5.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Safe)

+ (void)registerMutableArrayCrash;

@end
