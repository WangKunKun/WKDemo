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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomBtn];
    self.count = self.count;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)enterVC
{
    ViewController * vc = [[ViewController alloc] init];
    self.vc = vc;
    vc.count = self.count + 1;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    self.nav.title = [NSString stringWithFormat:@"%ld",count];
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


@end
