//
//  NSObject+DealBlock.h
//  KanManHua
//
//  Created by Wangkun on 2017/11/14.
//  Copyright © 2017年 - -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DealBlock)

- (id)addDeallocBlock:(void (^)())deallocBlock;

@end
