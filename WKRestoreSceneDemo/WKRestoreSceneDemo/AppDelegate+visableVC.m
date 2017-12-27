//
//  AppDelegate+visableVC.m
//  KanManHua
//
//  Created by wangkun on 2017/9/25.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import "AppDelegate+visableVC.h"

@implementation AppDelegate (visableVC)

+ (UIViewController *)getVisableVC
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [delegate getVisableVC];
}

+ (void)getNavVCWithBlock:(navClosure)closure
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate getNavVCWithBlock:closure];
}

+ (UIView *)getVisableView
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [delegate getVisableView];
}

- (UIViewController *)getVisableVC
{
    UIViewController * vc = self.window.rootViewController;
    while ([vc isKindOfClass:[UITabBarController class]]) {
        vc = ((UITabBarController *)vc).selectedViewController;
    }
    
    while ([vc isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)vc).visibleViewController;
    }
    
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

- (UIView *)getVisableView
{
    UIViewController * vc = [self getVisableVC];
    while (vc.tabBarController) {
        vc = vc.tabBarController;
    }
    while (vc.navigationController) {
        vc = vc.navigationController;
    }
    while (vc.tabBarController) {
        vc = vc.tabBarController;
    }
    while (vc.navigationController) {
        vc = vc.navigationController;
    }
    return vc.view;
}

- (void)getNavVCWithBlock:(navClosure)closure
{
    UIViewController * tmpVC = [self getVisableVC];
    UINavigationController * navi = tmpVC.navigationController;
    if (navi) {
        closure(navi);
    }
    else
    {
        [navi dismissViewControllerAnimated:YES completion:^{
            [self getNavVCWithBlock:closure];
        }];
    }
}

@end
