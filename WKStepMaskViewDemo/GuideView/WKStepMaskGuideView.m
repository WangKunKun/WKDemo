//
//  WKStepMaskGuideView.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/26.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKStepMaskGuideView.h"
#import <objc/runtime.h>



@implementation UIView (WKStepMaskGuideViewTag)

- (void)setWk_stepTag:(NSInteger)wk_stepTag
{
    objc_setAssociatedObject(self, @selector(wk_stepTag), @(wk_stepTag), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)wk_stepTag
{
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

@end

@implementation WKStepMaskModel

+ (instancetype)creatModelWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius step:(NSUInteger)step
{
    WKStepMaskModel * model = [WKStepMaskModel new];
    model.frame = frame;
    model.cornerRadius = cornerRadius;
    model.step = step;
    return model;
}
+ (instancetype)creatModelWithView:(UIView *)view cornerRadius:(CGFloat)cornerRadius step:(NSUInteger)step
{
    WKStepMaskModel * model = [WKStepMaskModel new];
    model.view = view;
    model.cornerRadius = cornerRadius;
    model.step = step;
    return model;
}

@end


@interface WKStepMaskGuideView ()

@property (nonatomic, strong) NSMutableArray <WKStepMaskModel *> * models;
@property (nonatomic, strong) NSMutableArray<UIView *> * views;
@property (nonatomic, strong) NSMutableArray<NSValue *> * rects;
@property (nonatomic, strong) CAShapeLayer * maskLayer;
@property (nonatomic, strong) NSMutableArray<NSNumber *> * steps;

//和model中的step的数字无关，只和models中包含的model 有多少个不同的steps有关
@property (nonatomic, assign) NSUInteger presentStep;

@end


@implementation WKStepMaskGuideView

@dynamic delegate;//覆写了 父；类的delegate属性后，新的delegate 继承了父类的delegate ，需要声明不由系统生成

- (instancetype)initWithModels:(NSArray <WKStepMaskModel *> *)models
{
    if (self = [super init]) {
        [self.models addObjectsFromArray:models];
        [self initData];
        [self configUI];
    }
    return self;
}

- (void)initData
{
    //排序
    [self.models sortUsingComparator:^NSComparisonResult(WKStepMaskModel *  _Nonnull obj1, WKStepMaskModel *  _Nonnull obj2) {
        return obj1.step > obj2.step;
    }];
    //整理
    UIView * keyView = [UIApplication sharedApplication].keyWindow;
    for (WKStepMaskModel * model in self.models) {
        //frame 无效 用view
        if (CGRectEqualToRect(model.frame, CGRectZero) || CGRectEqualToRect(model.frame, CGRectNull)) {
            if (model.view) {
                CGRect thisFrame = [model.view.superview convertRect:model.view.frame toView:keyView];
                [self.rects addObject:[NSValue valueWithCGRect:thisFrame]];
                UIView * view = [[UIView alloc] initWithFrame:thisFrame];
                view.wk_stepTag = model.step;
                [self.views addObject:view];
            }
            else
            {//走到这里 说明出错了，model传入的view 和frame 都是非法的 出现红色的view
                CGFloat width = 60;
                CGRect frame = CGRectMake(CGRectGetMidX(self.frame) - width/2.0, CGRectGetMidY(self.frame) - width/2.0, 60, 60);
                [self.rects addObject:[NSValue valueWithCGRect:frame]];
                UIView * view = [[UIView alloc] initWithFrame:frame];
                view.wk_stepTag = model.step;
                view.backgroundColor = [UIColor redColor];
                [self.views addObject:view];
            }
        }
        else //frame 有效 优先用frame
        {
            [self.rects addObject:[NSValue valueWithCGRect:model.frame]];
            UIView * view = [[UIView alloc] initWithFrame:model.frame];
            view.wk_stepTag = model.step;
            [self.views addObject:view];
        }
        BOOL isExist = NO;
        for (NSNumber * num in self.steps) {
            if ([num unsignedIntegerValue] == model.step) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            [self.steps addObject:@(model.step)];
        }
    }
    
}

- (void)configUI
{
    //去掉基类 赋予背景视图的 点击事件 重定义
    [self.bgView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.bgView removeGestureRecognizer:obj];
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeViewClick:)];
    [self.bgView addGestureRecognizer:tap];
    //设置背景view的steptag 防止其被隐藏
    self.bgView.wk_stepTag = -1;
    for (UIView * placeView in self.views) {
        placeView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeViewClick:)];
        [placeView addGestureRecognizer:tap];
        [self addSubview:placeView];
    }
    self.bgView.layer.mask = self.maskLayer;

    [self configInterFace];
}

- (void)placeViewClick:(UIGestureRecognizer *)gest
{
    self.presentStep += 1;
}



- (void)viewWillShow
{
    [super viewWillShow];
    //保障第一步正确
    self.presentStep = 0;
}

- (void)setPresentStep:(NSUInteger)presentStep
{
    [self viewWillEnterNextStep:presentStep];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWillChangeWithStep:view:)]) {
        [self.delegate viewWillChangeWithStep:self.presentStep view:self];
    }
    _presentStep = presentStep;
    if (_presentStep >= self.steps.count) {
        [self dismiss];
        return;
    }
    NSInteger step = [self.steps[_presentStep] integerValue];
    for (UIView * v in self.subviews) {
        if (v.wk_stepTag >= 0 ) {//保证不会操作到背景视图
            //这个地方的动画考虑如何优化
            if (v.wk_stepTag != step) {
                [UIView animateWithDuration:0.15 animations:^{
                    [self layoutIfNeeded];
                    v.alpha = 0;
                } completion:^(BOOL finished) {
                    v.hidden = YES;
                }];
            }
            else
            {
                v.alpha = 0;
                v.hidden = NO;
                [UIView animateWithDuration:0.15 animations:^{
                    [self layoutIfNeeded];
                    v.alpha = 1;
                }];
            }
        }
    }
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSUInteger i = 0;
    for (UIView * v in self.views) {
        if (v.wk_stepTag == step) {
            WKStepMaskModel * model = (WKStepMaskModel *)[self.models objectAtIndex:i];
            UIBezierPath * tmpPath = [[UIBezierPath bezierPathWithRoundedRect:v.frame cornerRadius:model.cornerRadius] bezierPathByReversingPath];
            [path appendPath:tmpPath];
        }
        i ++;
    }
    self.maskLayer.path = path.CGPath;
    //添加移动动画 如不需要 直接删除即可
    CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"path"];
    basic.toValue = path;
    [self.maskLayer addAnimation:basic forKey:@"aaa"];
    [self viewDidEnterNextStep:_presentStep];
}

- (NSMutableArray *)views
{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

- (NSMutableArray <WKStepMaskModel *> *)models
{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSMutableArray<NSValue *> *)rects
{
    if (!_rects) {
        _rects = [NSMutableArray array];
    }
    return _rects;
}

- (NSMutableArray *)steps
{
    if (!_steps) {
        _steps = [NSMutableArray array];
    }
    return _steps;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer new];
    }
    return _maskLayer;
}

///子类覆写
- (void)configInterFace{}
- (void)viewWillEnterNextStep:(NSUInteger)nextStep{}
- (void)viewDidEnterNextStep:(NSUInteger)nextStep{}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
