//
//  WKBaseView.m
//  KanManHua
//
//  Created by wangkun on 2017/11/8.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import "WKBaseView.h"
#import "WKViewManager.h"

@interface WKBaseView ()

@property (nonatomic, weak  ) UIView * parentView;
@property (nonatomic, assign) NSTimeInterval autoDissmissDelay;
@property (nonatomic, copy  ) voidClosure wk_dismissBlock;

@end
@implementation WKBaseView


- (void)setInterFace
{
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.bgView addGestureRecognizer:tap];
    _bgView.userInteractionEnabled = YES;
    self.userInteractionEnabled= YES;
    self.priority = WKBaseViewShowPriorityLow;
    self.alpha = 0;
}

#pragma mark 动画相关

- (void)showInView:(UIView *)view  isShow:(BOOL)flag
{
    if (flag) {
        //判断view 设置父视图
        self.parentView = [self getCurrentView:view];
        
        if (self.queueEnable) {
            [self viewWillEnterQueue];
            //判断进入队列的状态
            WKViewEnterQueueState state = [WKViewManager  addOperationWithView:self];
            if (state == WKViewEnterQueueStateSuccess) {
                [self viewDidEnterQueue];
            }
            else
            {
                [self viewEnterQueueFailedWithState:state];
            }
        }
        else
        {
            [self queueShow:YES];
        }
    }
    else
    {
        [self queueShow:NO];
    }
}

//抽离类 方便队列
- (void)queueShow:(BOOL)flag
{
    //由于一开始添加到view上，则需要先让其隐藏，所以show的时候，需要让其显示
    if (flag) {
        self.hidden = NO;
        if (!self.parentView) {
            [self removeFromSuperview];
            [self viewDidDismiss];
            return;
        }
        [self viewWillShow];
        if (self.autoDissmissDelay > 0) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:self.autoDissmissDelay];
        }
    }
    else
    {
        if (!self.superview) {
            return;
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        [self viewWillDismiss];
    }
    
    CGFloat alpha = flag;
    [self layoutIfNeeded];//先调用一次，是因为用的是约束，不先调用，会出现从左上角拉升的动画效果 不好
    [self updateContentViewConstraint:flag];
    [UIView animateWithDuration:self.animDuration animations:^{
        self.alpha = alpha;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            if (!flag) {
                self.parentView = nil;
                [self viewDidDismiss];
                [self removeFromSuperview];
            }
            else
            {
                [self viewDidShow];
                [self.superview bringSubviewToFront:self];
            }
        }
    }];
}

- (UIView *)getCurrentView:(UIView *)view
{
    //如果view为nil 则直接为keywindow
    UIView * keyView = [UIApplication sharedApplication].keyWindow;
    if (!view) {
        view = keyView;
    }
    else
    {
        //判断 vc的view 是否未加载完毕，如果未加载完毕，则可能出现 弹窗不正确的情况
        if (view.nextResponder && [view.nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController * responder  = (UIViewController *)view.nextResponder;
            if(![responder isViewLoaded])
            {
                view = keyView;
            }
        }
        
    }
    return view;
}

#pragma mark 便捷方式
- (void)dismiss
{
    [self queueShow:NO];
}

- (void)showInView:(UIView *)view autoDismissAfterDelay:(NSTimeInterval)time
{
    self.autoDissmissDelay = time;
    [self showInView:view isShow:YES];
}

#pragma mark setter
- (void)setBgClickToDismiss:(BOOL)bgClickToDismiss
{
    _bgClickToDismiss = bgClickToDismiss;
    self.bgView.userInteractionEnabled = bgClickToDismiss;
}

- (void)setParentView:(UIView *)parentView
{

    if ([parentView isEqual:_parentView]) {
        return;
    }
    _parentView = parentView;
    [self removeFromSuperview];
    if (parentView == nil) {
        return;
    }
    self.hidden = YES;
    self.alpha = 0;
    [_parentView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.parentView);
    }];
    [self updateContentViewConstraint:NO];
}

#pragma mark 父类方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        _animDuration = 0.25;
        _autoDissmissDelay = -1;
        _queueEnable = YES;
        [self setInterFace];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _animDuration = 0.25;
        _autoDissmissDelay = -1;
        _queueEnable = YES;
        [self setInterFace];
    }
    return self;
}

#pragma 子类继承实现

- (void)updateContentViewConstraint:(BOOL)isShow{}
- (void)viewWillShow{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WKView:lifecycleState:)]) {
        [self.delegate WKView:self lifecycleState:(WKViewStateWillShow)];
    }
}
- (void)viewDidShow{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WKView:lifecycleState:)]) {
        [self.delegate WKView:self lifecycleState:(WKViewStateDidShow)];
    }
}

- (void)viewWillEnterQueue{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WKView:lifecycleState:)]) {
        [self.delegate WKView:self lifecycleState:(WKViewStateWillEnterQueue)];
    }
}

- (void)viewEnterQueueFailedWithState:(WKViewEnterQueueState)state
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WKView:enterQueueFailed:)]) {
        [self.delegate WKView:self enterQueueFailed:state];
    }
}

- (void)viewDidEnterQueue{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WKView:lifecycleState:)]) {
        [self.delegate WKView:self lifecycleState:(WKViewStateDidEnterQueue)];
    }
}

- (void)viewWillDismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WKView:lifecycleState:)]) {
        [self.delegate WKView:self lifecycleState:(WKViewStateWillDismiss)];
    }
}

- (void)viewDidDismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WKView:lifecycleState:)]) {
        [self.delegate WKView:self lifecycleState:(WKViewStateDidDismiss)];
    }
    if (self.wk_dismissBlock) {
        self.wk_dismissBlock();
    }
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    if (self.wk_dismissBlock) {
        self.wk_dismissBlock();
    }
    self.wk_dismissBlock = nil;
}

- (BOOL)isEqual:(id)object
{
    if (!object) {
        return NO;
    }
    NSString * selfCN = NSStringFromClass([self class]);
    NSString * objCN = NSStringFromClass([object class]);
    NSString * selfAddress = [NSString stringWithFormat:@"%p",self];
    NSString * objAddress = [NSString stringWithFormat:@"%p",object];
    return [selfCN isEqualToString:objCN] && [selfAddress isEqualToString:objAddress];
}

@end

@interface WKViewOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@end

@implementation WKViewOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
        self.queuePriority = NSOperationQueuePriorityVeryLow;
    }
    return self;
}

- (void)start {
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    __weak typeof(self) weakSelf = self;
    //ui层级操作 加入主队列即可 gcd也可行
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [weakSelf.view queueShow:YES];
        weakSelf.view.wk_dismissBlock = ^{
            weakSelf.finished = YES;
        };
    }];
}

- (void)completion{
    self.finished = YES;
    self.view = nil;
}

- (void)cancel{
    if (self.isFinished) return;
    [super cancel];
}

- (void)setView:(WKBaseView *)view
{
    _view = view;
    //服务质量 比较明显，但是感觉不太合适
    switch (view.priority) {
        case WKBaseViewShowPriorityNormal:
            self.queuePriority =  NSOperationQueuePriorityNormal;
//            self.qualityOfService = NSQualityOfServiceUserInitiated;
            break;
        case WKBaseViewShowPriorityLow:
            self.queuePriority = NSOperationQueuePriorityLow;
            break;
        case WKBaseViewShowPriorityHigh:
            self.queuePriority = NSOperationQueuePriorityHigh;
            break;
        case WKBaseViewShowPriorityVeryLow:
            self.queuePriority = NSOperationQueuePriorityVeryLow;
            break;
        case WKBaseViewShowPriorityVeryHeight:
            self.queuePriority = NSOperationQueuePriorityVeryHigh;
            break;
    }
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end

