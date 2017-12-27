//
//  WKClassMethodModel.h
//  exchangeSetter
//
//  Created by wangkun on 2017/11/9.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface WKClassMethodModel : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) IMP oldIMP;
@property (nonatomic, assign) Method method;
+ (instancetype)createClassMethodModelWithMethod:(Method)property;


@end
