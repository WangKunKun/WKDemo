//
//  UIViewController+ViewManager.m
//  MKWeekly
//
//  Created by wangkun on 2018/5/23.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "UIViewController+ViewManager.h"
#import "NSObject+DealBlock.h"
#import "WKViewManager.h"
#import <objc/runtime.h>
static void *WKViewManagerVCDeallocHelperKey;

@implementation UIViewController (ViewManager)

+ (void)load
{
    Method viewDidLoad = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method myViewDidLoad = class_getInstanceMethod([self class], @selector(wkviewmanager_viewDidLoad));
    method_exchangeImplementations(viewDidLoad, myViewDidLoad);
    
    Method viewWillAppear = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method myViewWillAppear = class_getInstanceMethod([self class], @selector(wkviewmanager_viewWillAppear:));
    method_exchangeImplementations(viewWillAppear, myViewWillAppear);
    
    Method viewWillDisAppear = class_getInstanceMethod([self class], @selector(viewWillDisappear:));
    Method myViewWillDisAppear = class_getInstanceMethod([self class], @selector(wkviewmanager_viewWillDisappear:));
    method_exchangeImplementations(viewWillDisAppear, myViewWillDisAppear);
}

- (void)wkviewmanager_viewDidLoad
{
    [self wkviewmanager_viewDidLoad];
    //关键方法
    @synchronized (self) {
        @autoreleasepool {
            if (objc_getAssociatedObject(self, &WKViewManagerVCDeallocHelperKey) == nil) {
                __unsafe_unretained typeof(self) weakSelf = self; // NOTE: need to be __unsafe_unretained because __weak var will be reset to nil in dealloc
                id deallocHelper = [self addDealBlock:^{
                    [WKViewManager canclAllOperationWithVC:weakSelf];
                }];
                objc_setAssociatedObject(self, &WKViewManagerVCDeallocHelperKey, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
            }
        }
    }
}



- (void)wkviewmanager_viewWillAppear:(BOOL)animated
{
    [self wkviewmanager_viewWillAppear:animated];
    @synchronized (self) {
        [WKViewManager continueQueueWithObj:self];
        [WKViewManager showWaitViewWithVC:(UIViewController *)self];
    }
}


- (void)wkviewmanager_viewWillDisappear:(BOOL)animated
{
    [self wkviewmanager_viewWillDisappear:animated];
    @synchronized (self) {
        [WKViewManager suspendQueueWithObj:self];
    }
}



@end
