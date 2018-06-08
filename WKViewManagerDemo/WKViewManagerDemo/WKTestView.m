//
//  WKTestView.m
//  Study
//
//  Created by wangkun on 2018/6/8.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "WKTestView.h"

@interface WKTestView ()

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation WKTestView


- (void)setInterFace
{
    [super setInterFace];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(SCREEN_HEIGHT);
        make.width.height.equalTo(@200);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (void)updateContentViewConstraint:(BOOL)isShow
{
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(isShow ? 0 : SCREEN_HEIGHT);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
