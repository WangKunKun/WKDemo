//
//  WKViewManager.h
//  KanManHua
//
//  Created by wangkun on 2017/11/8.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBaseView.h"

@interface WKViewManager : NSObject

+ (instancetype)sharedManager;
///存在黑白名单机制，有可能无法进入队列
+ (WKViewEnterQueueState)addOperationWithView:(WKBaseView *)view;
//在vc willappear中调用 已写入运行时
+ (void)showWaitViewWithVC:(UIViewController *)vc;
///vc dealloc时 调用，已写入 运行时类目中 
+ (void)canclAllOperationWithVC:(UIViewController *)vc;
//vcWillDissAppear时调用 暂停队列
+ (void)suspendQueueWithObj:(NSObject *)obj;
//vcWillAppear时调用 让暂停队列启动
+ (void)continueQueueWithObj:(NSObject *)obj;

@end
