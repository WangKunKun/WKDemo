//
//  WKBaseGuideView.m
//  KanManHua
//
//  Created by wangkun on 2017/9/13.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import "WKKMBaseGuideView.h"
@interface WKKMBaseGuideView ()


@property (nonatomic, weak) UINavigationController * nav;
@property (nonatomic, assign) BOOL navLeftSwipEnableIsChanged;//是否认为改变过nav的左滑手势
@end

@implementation WKKMBaseGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark 布局相关
- (void)setInterFace
{
    [super setInterFace];
    
    _navLeftSwipEnableIsChanged = NO;
    
    self.alpha = 0;

    self.priority = WKBaseViewShowPriorityHigh;
    self.tag = wkBaseGuideViewTag;
}



#pragma mark 动画相关

- (void)viewWillShow
{
    [super viewWillShow];
    //引导图模式期间 不支持左滑返回操作
    if ([[self.superview nextResponder] isKindOfClass:[UINavigationController class]]) {
        _nav = [self.superview nextResponder];
    }    
    if (_nav.interactivePopGestureRecognizer.enabled) {
        _navLeftSwipEnableIsChanged = YES;//记录是否改变，
        _nav.interactivePopGestureRecognizer.enabled = NO;
    }

}

- (void)viewWillDismiss
{
    [super viewWillDismiss];
    if (_navLeftSwipEnableIsChanged) {//改变过后 直接返回
        _nav.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidDismiss
{
    [super viewDidDismiss];
    if (_delegate && [_delegate respondsToSelector:@selector(didDismissWithView:)]) {
        [_delegate didDismissWithView:self];
    }
}

@end
