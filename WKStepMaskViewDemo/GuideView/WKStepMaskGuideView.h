//
//  WKStepMaskGuideView.h
//  MKWeekly
//
//  Created by wangkun on 2018/3/26.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKKMBaseGuideView.h"


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@class WKStepMaskGuideView;

//UIView 类目  用于控制布局 不同step时的指向性view的 wk_steptag
@interface UIView (WKStepMaskGuideViewTag)

@property (nonatomic, assign) NSInteger wk_stepTag;

@end

///首先构建一个模型，圆角度
@interface WKStepMaskModel : NSObject

///基于keywindow的frame
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIView * view;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) NSUInteger step;

///推荐使用此方法 计算好frame传入
+ (instancetype)creatModelWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius step:(NSUInteger)step;
///推荐使用withframe方法初始化 如若传入view  只会取此view对应其俯视图的frame，如果布局层级过深可能会有差错。
+ (instancetype)creatModelWithView:(UIView *)view cornerRadius:(CGFloat)cornerRadius step:(NSUInteger)step;

@end

@protocol WKStepMaskGuideViewDelegate<WKKMBaseGuideViewDelegate>

- (void)viewWillChangeWithStep:(NSUInteger)step view:(WKStepMaskGuideView *)view;

@end

@interface WKStepMaskGuideView : WKKMBaseGuideView

@property (nonatomic, strong, readonly) NSMutableArray<UIView *> * views;
@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> * rects;
@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> * steps;

@property (nonatomic, weak  ) id<WKStepMaskGuideViewDelegate> delegate;
///models中的model的step可以无序，内部会进行排序，生成的views根据step排序
- (instancetype)initWithModels:(NSArray <WKStepMaskModel *> *)models;


///子类覆写
- (void)configInterFace;
///此方法 先调用与代理方法 willchange
- (void)viewWillEnterNextStep:(NSUInteger)nextStep;
- (void)viewDidEnterNextStep:(NSUInteger)nextStep;
@end

