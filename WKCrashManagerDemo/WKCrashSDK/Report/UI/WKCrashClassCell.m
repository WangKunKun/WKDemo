//
//  WKCrashClassCell.m
//  MKWeekly
//
//  Created by wangkun on 2018/7/8.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKCrashClassCell.h"
#import "UIViewExt.h"
@interface WKCrashClassCell ()

@end
@implementation WKCrashClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self.contentView addSubview:self.countLabel];
    
    self.countLabel.frame = CGRectMake(SCREEN_WIDTH - 16 - 30, 16, 30, 16);
    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH - 16 - 100, 55, 110, 16);

    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.titleLabel];
    
    self.titleLabel.frame = CGRectMake(16, 16, SCREEN_WIDTH - 16 - 30 - 115, 100 - 16 * 2);
    
    UIView * line = [UIView new];
    [self.contentView addSubview:line];
    line.frame = CGRectMake(0, 100 - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = APPMainColor;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.textColor = APPMainColor;
        _countLabel.font = HJTFont(13);
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = APPMainColor;
        _titleLabel.font = HJTFont(14);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = APPMainColor;
        _timeLabel.font = HJTFont(10);
        _timeLabel.textAlignment = NSTextAlignmentRight;

    }
    return _timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
