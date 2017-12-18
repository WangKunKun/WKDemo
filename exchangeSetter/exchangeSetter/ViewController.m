//
//  ViewController.m
//  exchangeSetter
//
//  Created by wangkun on 2017/11/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"
@interface ViewController ()

@property (nonatomic, strong) UIView * aa;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __block UserModel * model = [UserModel new];
    model.userID = 123;
    model.userName = @"aaa";
    model.isGirl = YES;
    NSLog(@"%@,%ld,%ld",model.userName,model.userID,model.isGirl);
    _aa = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _aa.backgroundColor = [UIColor redColor];
    [self.view addSubview:_aa];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        model = nil;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
