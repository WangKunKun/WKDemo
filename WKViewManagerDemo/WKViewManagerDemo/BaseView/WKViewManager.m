//
//  WKViewManager.m
//  KanManHua
//
//  Created by wangkun on 2017/11/8.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import "WKViewManager.h"
///黑名单中，对应的键包含这个则表明对应的vc不显示任何wkbaseview的基类
static const NSString * const WK_AllViewNickName = @"WKBaseViewAllNotAllowed";

@interface WKViewManager ()

@property (nonatomic,strong) NSMutableArray <NSOperationQueue *> * queueList;
@property (nonatomic,strong) NSMutableArray<WKBaseView *> * blackListView;
@property (nonatomic,strong) NSMutableArray<WKBaseView *> * whiteListView;

@end

@implementation WKViewManager



+ (instancetype)sharedManager
{
    static WKViewManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WKViewManager alloc] init];
    });
    return manager;
}

+ (void)suspendQueueWithObj:(NSObject *)obj
{
    NSOperationQueue * queue = [[WKViewManager sharedManager] findQueueWithObject:obj];
    queue.suspended = YES;
}

+ (void)continueQueueWithObj:(NSObject *)obj
{
    NSOperationQueue * queue = [[WKViewManager sharedManager] findQueueWithObject:obj];
    queue.suspended = NO;
}

#pragma mark 队列相关
+ (WKViewEnterQueueState)addOperationWithView:(WKBaseView *)view
{
    //判断view是否存在
    
    if (!view.parentView) {
        NSLog(@"父视图不存在了");
        return WKViewEnterQueueStateFailed_ParentViewIsNil;
    }
    //黑名单检测，如果位于黑名单内则进入首页后再显示
    NSObject * obj = view.parentView.nextResponder ?: view.parentView;
    WKViewManager * vm = [WKViewManager sharedManager];
    
    NSDictionary * blackList = [WKViewManager blackList];
    for (NSString * cn in blackList.allKeys) {
        {
            
            if ([obj isKindOfClass:NSClassFromString(cn)]) {
                NSArray * viewNames = [blackList objectForKey:cn];
                //这里用包含，是因为是静态不变的常量
                if ([viewNames containsObject:WK_AllViewNickName]) {
                    [vm.blackListView addObject:view];
                    return WKViewEnterQueueStateFailed_BlackListCheckFailed;
                }
                else
                {
                    for (NSString * vn in viewNames) {
                        if ([vn isEqualToString:NSStringFromClass([view class])]) {
                            [vm.blackListView addObject:view];
                            return WKViewEnterQueueStateFailed_BlackListCheckFailed;
                        }
                    }
                }
            }
        }
    }
    //白名单检测，如果位于白名单，则查看对应的parentview的nextresponder 是否符合vc类名
    NSDictionary * whiteList = [WKViewManager whiteList];
    BOOL whiteListCheckResult = YES;//白名单检测结果，如果均未匹配上为NO,默认为yes，防止view未在白名单内，结果被no了
    for (NSString * cn in [whiteList allKeys]) {
        //view 位于白名单内
        if ([view isKindOfClass:NSClassFromString(cn)])
        {
            //view 位于白名单内，则先设置为NO
            whiteListCheckResult = NO;
            NSArray * values = [whiteList objectForKey:cn];
            if (values.count <= 0) {
                continue;
            }
            //得到view可展示的vc的类名
            for (NSString * vcNames in values) {
                //如果 obj的类名能匹配到vc的类名，则显示
                if ([obj isKindOfClass:NSClassFromString(vcNames)]) {
                    whiteListCheckResult = YES;
                    break;
                }
            }
        }
    }
    //为YES,则检测通过 可显示，为no则检测失败 进入等待数组
    if (!whiteListCheckResult) {
        [vm.whiteListView addObject:view];
        return WKViewEnterQueueStateFailed_WhiteListCheckFailed;
    }
    
    //存在检测，如果队列中已存在需要show的view则不显示
    BOOL isContain = NO;
    NSOperationQueue * queue = [vm getQueueWithObject:obj];
    for (WKViewOperation * op in [queue operations]) {
        if ([op.view isEqual:view]) {
            isContain = YES;
            break;
        }
    }
    //存在直接返回
    if (isContain) {
        return WKViewEnterQueueStateFailed_Repetition;
    }
    WKViewOperation * op = [WKViewOperation new];
    op.view = view;
    [queue addOperation:op];
    return WKViewEnterQueueStateSuccess;
}

+ (void)canclAllOperationWithVC:(UIViewController *)vc
{
    if (!vc) {
        return;
    }
    WKViewManager * vm = [WKViewManager sharedManager];
    NSOperationQueue * queue = [vm findQueueWithObject:vc];
    if (queue) {
        for (WKViewOperation * op in [queue operations]) {
            [op.view removeFromSuperview];
            [op completion];
        }
        [vm.queueList removeObject:queue];
    }

}

- (NSOperationQueue *)getQueueWithObject:(NSObject *)obj
{
    NSString * key = [NSString stringWithFormat:@"%@+%p",NSStringFromClass([obj class]),obj];
    NSOperationQueue * queue = [self findQueueWithObject:obj];
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        queue.name = key;
        queue.maxConcurrentOperationCount = 1;
        [self.queueList addObject:queue];
    }

    return queue;
}

- (nullable NSOperationQueue *)findQueueWithObject:(NSObject *)obj
{
    if (!obj) {
        return nil;
    }
    NSString * key = [NSString stringWithFormat:@"%@+%p",NSStringFromClass([obj class]),obj];
    NSOperationQueue * queue = nil;
    for (NSOperationQueue * tmpQ in self.queueList) {
        if ([tmpQ.name isEqualToString:key]) {
            queue = tmpQ;
            break;
        }
    }
    return queue;
}



- (NSMutableArray<NSOperationQueue *> *)queueList
{
    if (!_queueList) {
        _queueList = [NSMutableArray array];
    }
    return _queueList;
}

- (NSMutableArray<WKBaseView *> *)blackListView
{
    if (!_blackListView) {
        _blackListView = [NSMutableArray array];
    }
    return _blackListView;
}

- (NSMutableArray<WKBaseView *> *)whiteListView
{
    if (!_whiteListView) {
        _whiteListView = [NSMutableArray array];
    }
    return _whiteListView;
}

#pragma blackList and whiteList show in vc
//Waring 如需要更改为vc的navvc或者tabvc，请前往白名单黑名单列表修改，不能于此处直接修改，否则会造成无限循环导致崩溃
+ (void)showWaitViewWithVC:(UIViewController *)vc
{
    WKViewManager * vm = [WKViewManager sharedManager];
    //处理黑名单
    if ([vc isKindOfClass:NSClassFromString([self blackListHomeVCClassName])])
    {
        [vm.blackListView enumerateObjectsUsingBlock:^(WKBaseView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj showInView:vc.view isShow:YES];
        }];
        [vm.blackListView removeAllObjects];
    }
    //处理白名单
    NSString * vcClassName = NSStringFromClass([vc class]);
    NSMutableArray * didShowViews = [NSMutableArray array];
    for (WKBaseView * baseView in vm.whiteListView) {
        NSArray * values = [[self whiteList] objectForKey:NSStringFromClass([baseView class])];//vc类名
        for (NSString * vcCN in values) {
            if ([vcCN isEqualToString:vcClassName]) {
                [baseView showInView:vc.view isShow:YES];
                [didShowViews addObject:baseView];
                break;
            }
        }
    }
    [vm.whiteListView removeObjectsInArray:didShowViews];
    
}

#pragma mark 黑名单  以vc为主体(key)，对应vc中不允许出现的view(values)，不允许出现的view在vc中被show时，均返回blackListHomeVCClassName中再调用
///key 为字符串，value为字符串数组
+ (NSDictionary *)blackList
{
    static NSDictionary *blackList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blackList = @{
                      @"HomePageVC":@[@"WKTestView"],
                      };
    });
    return blackList;
}
//黑名单中的view 显示的vc
+ (NSString *)blackListHomeVCClassName
{
    static NSString * homeVCClassName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        homeVCClassName = @"DetailPageVC";
    });
    return homeVCClassName;
}
#pragma mark 等待增加白名单  白名单以view为主体（key），view只允许出现在对应的vc（values）
///key 为字符串，value为字符串数组
+ (NSDictionary *)whiteList
{
 
    static NSDictionary *whiteList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        whiteList = @{
                      @"WKOtherView":@[@"HomePageVC"],
                      };
    });
    return whiteList;
}


@end
