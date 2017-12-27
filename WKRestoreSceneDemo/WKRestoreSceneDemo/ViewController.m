//
//  ViewController.m
//  WKRestoreSceneDemo
//
//  Created by wangkun on 2017/12/27.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+RestoreScene.h"
@interface ViewController ()

@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSUInteger count;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.label];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:btn];
    btn.bounds = CGRectMake(0, 0, 100, 40);
    btn.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 40);
    [btn setTitle:@"下一页" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor colorWithRed:1 green:111/255.0 blue:111/255.0 alpha:1] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnCLick:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [NSString stringWithFormat:@"%ld",self.count];
    self.content = [NSString stringWithFormat:@"这是第%ld页",self.count];
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:30];
        _label.textColor = [UIColor colorWithRed:1 green:111/255.0 blue:111/255.0 alpha:1];
        _label.center = self.view.center;
        _label.numberOfLines = 0;
        _label.bounds = CGRectMake(0, 0, 200, 100);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)btnCLick:(UIButton *)sender {
    ViewController * vc = [ViewController new];
    vc.count = self.count + 1;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)setContent:(NSString *)content
{
    _content = content;
    self.label.text = content;
}

+ (NSArray *)restoreSceneKey
{
    return  @[@"count"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
