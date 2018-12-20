//
//  WKZombieManager.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/9.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WKZombieStub : NSObject

@property (readwrite,assign,nonatomic) Class origClass;

@end
@interface WKZombieManager : NSObject

@property (nonatomic, strong) NSMutableArray * zombieClassArr;
+ (instancetype)sharedZombieManager;
+ (void)registerZombieCrashWithClassArr:(NSArray *)classArr;

@end
