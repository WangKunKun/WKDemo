//
//  WKMsgReceiver.h
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/4.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKMsgReceiver : NSObject

+ (instancetype)sharedMsgReceiver;
- (BOOL)addFunc:(SEL)sel;
+ (BOOL)addClassFunc:(SEL)sel;
@end
