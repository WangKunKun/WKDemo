//
//  UserModel.m
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "UserModel.h"


@interface UserModel ()

@property (nonatomic, strong) NSString * userDetail;

@end

@implementation UserModel

WKDataBaseSetter

- (void)setUserID:(NSUInteger)userID
{
    _userID = userID;
    NSLog(@"修改userid");
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    NSLog(@"修改username");
}

+ (NSArray *)DBMainKey
{
    return @[@"userID"];
}

@end
