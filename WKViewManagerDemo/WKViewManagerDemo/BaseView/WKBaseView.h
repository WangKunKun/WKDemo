//
//  WKBaseView.h
//  KanManHua
//
//  Created by wangkun on 2017/11/8.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHeader.h"

@class WKBaseView;

typedef enum : NSUInteger {
    WKViewStateWillEnterQueue,
    WKViewStateDidEnterQueue,
    WKViewStateWillShow,
    WKViewStateDidShow,
    WKViewStateWillDismiss,
    WKViewStateDidDismiss
} WKViewState;

typedef enum : NSUInteger {
    WKViewEnterQueueStateSuccess,
    WKViewEnterQueueStateFailed_Repetition,//重复，队列中已包含相同实例
    WKViewEnterQueueStateFailed_BlackListCheckFailed,//位于黑名单中，不符合黑名单显示规则
    WKViewEnterQueueStateFailed_WhiteListCheckFailed,//位于白名单中，不符合白名单显示规则
    WKViewEnterQueueStateFailed_ParentViewIsNil//未知原因导致parentview为nil
} WKViewEnterQueueState;

@protocol WKBaseViewDelegate <NSObject>


@optional
- (void)WKView:(WKBaseView *)view lifecycleState:(WKViewState)state;
- (void)WKView:(WKBaseView *)view enterQueueFailed:(WKViewEnterQueueState)state;

@end

typedef enum : NSUInteger {
    WKBaseViewShowPriorityVeryLow,
    WKBaseViewShowPriorityLow,
    WKBaseViewShowPriorityNormal,
    WKBaseViewShowPriorityHigh,
    WKBaseViewShowPriorityVeryHeight,
} WKBaseViewShowPriority;

@interface WKBaseView : UIView

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, assign) CGFloat animDuration;//动画效果时间  默认0.25
@property (nonatomic, weak, readonly) UIView * parentView;
@property (nonatomic, assign) WKBaseViewShowPriority priority;
@property (nonatomic, assign) BOOL bgClickToDismiss;
@property (nonatomic, weak  ) id <WKBaseViewDelegate> delegate;

///慎用！！继承此类的视图都需要进入队列，如不进入队列的特殊需求，请标注说明
@property (nonatomic, assign) BOOL queueEnable;

/**
 布局方法 子类 布局需复写  复写需先调用基类方法
 */
- (void)setInterFace NS_REQUIRES_SUPER;
/**
 执行出现和消失动画前会调用  若需要自定义动画 在此方法中设置改变后的动画属性对应值   动画时会自动调用
 
 @param isShow show or dismiss
 */
- (void)updateContentViewConstraint:(BOOL)isShow;//于此方法中调整布局 也达到消失动画 和 出现动画自定义

//展示方法 基本
- (void)dismiss;
- (void)showInView:(UIView *)view  isShow:(BOOL)flag NS_REQUIRES_SUPER;

//展示在view上  过time秒后 自动隐藏
- (void)showInView:(UIView *)view autoDismissAfterDelay:(NSTimeInterval)time NS_REQUIRES_SUPER;
//周期方法

//队列方法 需要queueenable 为yes时调用
- (void)viewWillEnterQueue NS_REQUIRES_SUPER;
- (void)viewEnterQueueFailedWithState:(WKViewEnterQueueState)state NS_REQUIRES_SUPER;
- (void)viewDidEnterQueue NS_REQUIRES_SUPER;

- (void)viewWillShow NS_REQUIRES_SUPER;
- (void)viewDidShow NS_REQUIRES_SUPER;
- (void)viewWillDismiss NS_REQUIRES_SUPER;
- (void)viewDidDismiss NS_REQUIRES_SUPER;

@end

@interface WKViewOperation : NSOperation
@property (nonatomic, weak) WKBaseView * view;
- (void)completion;
@end
