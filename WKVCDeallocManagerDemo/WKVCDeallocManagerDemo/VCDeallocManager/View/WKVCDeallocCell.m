//
//  WKVCDeallocCell.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/21.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKVCDeallocCell.h"
#import "WKVCDeallocManger.h"
@interface WKVCDeallocCell ()
@property (strong, nonatomic) IBOutlet UIImageView *IV;
@property (strong, nonatomic) IBOutlet UILabel *classNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIView *dotView;

@end

@implementation WKVCDeallocCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dotView.layer.cornerRadius = 7.5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.dotView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
    [self.IV addGestureRecognizer:tap];
}

- (void)setModel:(WKDeallocModel *)model
{
    _model = model;
    self.IV.image = model.img;
    self.classNameLabel.text = model.className;
    [self.classNameLabel sizeToFit];
    self.addressLabel.text = model.address;
    self.dotView.hidden = !model.isNeedRelease;//显示既有问题
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)imgClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithImg:)]) {
        [self.delegate clickWithImg:self.model.img];
    }
}

@end
