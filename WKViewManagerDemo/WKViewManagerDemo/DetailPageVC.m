//
//  DetailPageVC.m
//  WKViewManagerDemo
//
//  Created by wangkun on 2018/6/8.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "DetailPageVC.h"
#import "WKOtherView.h"
@interface DetailPageVC ()

@end

@implementation DetailPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showView:(id)sender {
    WKOtherView * v = [[WKOtherView alloc] init];
    v.title = @"This is Other View Must Show in home page";
    [v showInView:self.view isShow:YES];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
