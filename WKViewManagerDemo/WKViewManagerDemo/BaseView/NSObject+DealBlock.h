//
//  NSObject+DealBlock.h
//  KanManHua
//
//  Created by Banning on 2017/11/14.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKHeader.h"


@interface NSObject (DealBlock)

- (id)addDealBlock:(voidClosure)deallocBlock;

@end
