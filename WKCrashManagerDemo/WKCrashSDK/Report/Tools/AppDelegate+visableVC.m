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


- (UIViewController *)getVisableVC
{
    UIViewController * vc = self.window.rootViewController;

    while ([vc isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)vc).visibleViewController;
    }
    

    
    while ([vc isKindOfClass:[UITabBarController class]]) {
        vc = ((UITabBarController *)vc).selectedViewController;
    }
    
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    
    return vc;
}

- (UIView *)getVisableView
{
    UIViewController * vc = [self getVisableVC];
    return vc.view;
}

- (void)getNavVCWithBlock:(navClosure)closure
{
    UIViewController * tmpVC = [self getVisableVC];
    //如果是tabbar 则需要选定的vc
    if ([tmpVC isKindOfClass:[UITabBarController class]]) {
        tmpVC = ((UITabBarController *)tmpVC).selectedViewController;
    }
    //如果选定的vc 是nav或者nav不为nil，则直接返回
    UINavigationController * navi = [tmpVC isKindOfClass:[UINavigationController class]] ? (UINavigationController*)tmpVC : tmpVC.navigationController;
    
    if (navi) {
        closure(navi);
    }
    else
    {
        //问题出现 如果tmpvc 不是nav 且没有nav
        //如果是被present出来的vc，则先dismiss再尝试寻找nav
        if (tmpVC.presentingViewController) {
            [tmpVC dismissViewControllerAnimated:YES completion:^{
                [self getNavVCWithBlock:closure];
            }];
        }
        else//如果不是，则nil，暂不处理
        {
            //考虑人为创建
            //            closure(nil);
        }

    }
}

@end
