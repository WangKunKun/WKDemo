//
//  WKLifeCircleRecordCell.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/22.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKLifeCircleRecordCell.h"
#import "WKVCLifeCircleRecordManager.h"
@interface WKLifeCircleRecordCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@end

@implementation WKLifeCircleRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WKVCLifeCircleRecordModel *)model
{
    _model = model;
    self.titleLabel.text = model.className;
    self.subTitleLabel.text = model.address;
    self.detailLabel.text = [[model.methodName componentsSeparatedByString:@"_"].lastObject stringByReplacingOccurrencesOfString:@"]" withString:@""];
}

@end
