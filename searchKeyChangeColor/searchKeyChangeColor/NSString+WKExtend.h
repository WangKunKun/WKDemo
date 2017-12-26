//
//  NSString+WKExtend.h
//  searchKeyChangeColor
//
//  Created by wangkun on 2017/12/26.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^PYDictBlock)(NSDictionary<NSNumber *,NSMutableArray *>  *);

@interface NSString (WKExtend)
- (NSArray *)getAllRangeOfString:(NSString *)searchString;
+ (NSString *)transform:(NSString *)chinese;
+ (NSString *)changeChineseToPinYin:(NSString *)str block:(PYDictBlock)dictBlock;
+ (NSString *)changeChineseToPinYinFirstLetter:(NSString *)str;
+ (BOOL)IsChineseForString:(NSString *)string;
@end
