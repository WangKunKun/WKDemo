//
//  ViewController.m
//  WKViewManagerDemo
//
//  Created by wangkun on 2018/6/8.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "HomePageVC.h"
#import "WKTestView.h"
@interface HomePageVC ()

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showView:(id)sender {
    WKTestView * v = [[WKTestView alloc] init];
    v.title = @"This is Test View can not show in HomePage";
    [v showInView:self.view isShow:YES];
}

@end
