//
//  WKBaseGuideView.h
//  KanManHua
//
//  Created by wangkun on 2017/9/13.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import "WKBaseView.h"
//view tag 特殊情况使用
static CGFloat wkBaseGuideViewTag = 10088;

@protocol WKKMBaseGuideViewDelegate<NSObject>

- (void)didDismissWithView:(WKBaseView *)view;

@end

@interface WKKMBaseGuideView : WKBaseView
@property (nonatomic, weak  ) id<WKKMBaseGuideViewDelegate> delegate;

@end
