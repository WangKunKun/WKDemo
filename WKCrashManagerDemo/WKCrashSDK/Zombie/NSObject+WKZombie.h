//
//  NSObject+Zombie.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/9.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WKZombie)

- (void)wkzombiesafe_dealloc;

@end
