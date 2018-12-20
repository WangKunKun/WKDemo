//
//  WKCrashListCell.m
//  MKWeekly
//
//  Created by wangkun on 2018/7/8.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKCrashListCell.h"
#import "UIViewExt.h"
@interface WKCrashListCell ()



@end

@implementation WKCrashListCell

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
    self.countLabel.frame = CGRectMake(SCREEN_WIDTH - 30 - 16, (100 - 25) / 2.f, 30, 25);
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.frame = CGRectMake(16, 16,  SCREEN_WIDTH - 30 - 16 - 16 - 10 , 100 - 16);
    UIView * line = [UIView new];
    line.backgroundColor = APPMainColor;
    line.frame = CGRectMake(0, 100 - 0.5, SCREEN_WIDTH, 0.5);
    [self.contentView addSubview:line];

    
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.font = HJTFont(13);
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.textColor = APPMainColor;
    }
    return _countLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = HJTFont(16);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = APPMainColor;
    }
    return _titleLabel;
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
