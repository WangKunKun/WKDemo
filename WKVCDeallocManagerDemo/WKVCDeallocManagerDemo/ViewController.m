//
//  ViewController.m
//  WKVCDeallocManagerDemo
//
//  Created by wangkun on 2018/3/26.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) ViewController * vc;
@property (nonatomic, strong) UIButton * bottomBtn;
@property (nonatomic,strong) UIButton * leftBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.bottomBtn];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn setTitle:@"退出" forState:(UIControlStateNormal)];
        [_leftBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        _leftBtn.frame = CGRectMake(0, 20, 60, 44);
    }
    return _leftBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_bottomBtn setTitle:@"enter" forState:(UIControlStateNormal)];
        [_bottomBtn setBackgroundColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1]];
        [_bottomBtn addTarget:self action:@selector(enterVC) forControlEvents:(UIControlEventTouchUpInside)];
        _bottomBtn.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 60, CGRectGetMidY(self.view.frame) - 20, 120, 40);
    }
    return _bottomBtn;
}

- (void)enterVC
{
    ViewController * vc = [[ViewController alloc] init];
    self.vc = vc;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
