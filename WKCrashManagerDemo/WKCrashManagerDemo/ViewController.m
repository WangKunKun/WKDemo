//
//  ViewController.m
//  WKCrashManagerDemo
//
//  Created by wangkun on 2018/12/10.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)methodNotFountClick:(id)sender {
    
    UIView * v = self;
    UIView * new = [UIView new];
    [v addSubview:new];
}

- (IBAction)arrarAddNilClick:(id)sender {
    NSMutableArray * arr = [NSMutableArray array];
    id a = nil;
    [arr addObject:a];
}

- (IBAction)strAppendNilClick:(id)sender {
    NSMutableString * str = [NSMutableString string];
    NSString * s = nil;
    [str appendString:s];
}


@end
