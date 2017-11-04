//
//  UserModel.h
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject

@property (nonatomic, strong) NSString * userName;
@property (nonatomic, assign) NSUInteger userID;
@property (nonatomic, assign) BOOL isGirl;

@end
