//
//  WKClassPropertyModel.h
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface WKClassPropertyModel : NSObject

@property (nonatomic, strong) NSString * setterName;
@property (nonatomic, strong) NSString * getterName;
@property (nonatomic, strong) NSString * varName;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * name;

+ (instancetype)createClassPropertyModelWithProperty:(objc_property_t)property;


@end
