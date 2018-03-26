//
//  StepMaskGuideView.m
//  WKStepMaskViewDemo
//
//  Created by wangkun on 2018/3/26.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "StepMaskGuideView.h"

@interface StepMaskGuideView ()

@property (nonatomic, strong) UILabel * nextLabel;
@property (nonatomic, strong) UILabel * finishLabel;

@end

@implementation StepMaskGuideView

- (void)configInterFace
{
    [self addSubview:self.nextLabel];
    [self addSubview:self.finishLabel];
    
    self.nextLabel.frame = CGRectMake(CGRectGetMinX(self.views.firstObject.frame), CGRectGetMaxY(self.views.firstObject.frame) + 10, 50, 18);
    self.nextLabel.wk_stepTag = self.views.firstObject.wk_stepTag;//必备   设置其需要与的view同时出现的steptag
    
    self.finishLabel.frame = CGRectMake(CGRectGetMinX(self.views.lastObject.frame), CGRectGetMaxY(self.views.lastObject.frame) + 10, 50, 18);
    self.finishLabel.wk_stepTag = self.views.lastObject.wk_stepTag;
}

- (UILabel *)nextLabel
{
    if (!_nextLabel) {
        _nextLabel = [UILabel new];
        _nextLabel.textColor = [UIColor whiteColor];
        _nextLabel.font = [UIFont systemFontOfSize:15];
        _nextLabel.text = @"下一步";
        _nextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nextLabel;
}

- (UILabel *)finishLabel
{
    if (!_finishLabel) {
        _finishLabel = [UILabel new];
        _finishLabel.textColor = [UIColor whiteColor];
        _finishLabel.font = [UIFont systemFontOfSize:15];
        _finishLabel.text = @"完成";
        _finishLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _finishLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
