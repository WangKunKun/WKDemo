//
//  KMDeallocBlockExecutor.h
//  KanManHua
//
//  Created by wangkun on 2017/11/14.
//  Copyright © 2017年 - -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMDeallocBlockExecutor : NSObject

+ (instancetype)executorWithDeallocBlock:(void (^)())deallocBlock;

@property (nonatomic, copy) void (^deallocBlock)();

@end
