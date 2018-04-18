//
//  WKHeader.h
//  WKVCDeallocManagerDemo
//
//  Created by wangkun on 2018/4/18.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#ifndef WKHeader_h
#define WKHeader_h
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define NAVIGATION_STATUS_HEIGHT (IS_IPHONE_X ? 88.f : 64.f)

#endif /* WKHeader_h */
