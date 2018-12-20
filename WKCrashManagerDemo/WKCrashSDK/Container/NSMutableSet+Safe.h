//
//  NSMutableSet+Safe.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/6.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet (Safe)
+ (void)registerMutableSetCrash;
@end
