//
//  ViewController.m
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"
#import "UserModel+Setter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UserModel * model = [UserModel new];
    model.userID = 123;
    model.userName = @"aaa";
    model.isGirl = YES;
    NSLog(@"%@,%ld,%ld",model.userName,model.userID,model.isGirl);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
