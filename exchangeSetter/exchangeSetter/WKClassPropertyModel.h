//
//  WKClassPropertyModel.h
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum : NSUInteger {
    WKPropertyType_Object,
    WKPropertyType_CNumber,
    WKPropertyType_Unknown,
} WKPropertyType;

@interface WKClassPropertyModel : NSObject

@property (nonatomic, strong) NSString * setterName;
@property (nonatomic, strong) NSString * getterName;
@property (nonatomic, strong) NSString * varName;
@property (nonatomic, strong) NSString * typeName;
@property (nonatomic, assign) WKPropertyType type;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) IMP oldsetterIMP;

+ (instancetype)createClassPropertyModelWithProperty:(objc_property_t)property;


@end
