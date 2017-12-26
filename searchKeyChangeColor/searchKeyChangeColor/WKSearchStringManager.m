//
//  WKSearchStringManager.m
//  MKWeekly
//
//  Created by wangkun on 2017/12/26.
//  Copyright © 2017年 zymk. All rights reserved.
//

#import "WKSearchStringManager.h"
#import "NSString+WKExtend.h"
@interface WKSearchStringManager ()

@property (nonatomic, strong) NSString * searchPYStr;
@property (nonatomic, strong) NSString * sourcePYStr;

@property (nonatomic, strong) NSDictionary <NSNumber *,NSMutableArray *> * searchPYDict;
@property (nonatomic, strong) NSDictionary <NSNumber *,NSMutableArray *> * sourcePYDict;


@end


@implementation WKSearchStringManager

+ (instancetype)sharedSearchStringManager
{
    static WKSearchStringManager * wkssm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wkssm = [WKSearchStringManager new];
    });
    return wkssm;
}

- (void)setSourceStr:(NSString *)sourceStr
{
    if ( sourceStr != nil && sourceStr.length > 0 && ![_sourceStr isEqualToString:sourceStr]) {
        _sourceStr = sourceStr;
        self.sourcePYStr = [NSString changeChineseToPinYin:_sourceStr block:^(NSDictionary<NSNumber *,NSMutableArray *> *dict) {
            self.sourcePYDict = dict;
        }];
    }
}

- (void)setSearchStr:(NSString *)searchStr
{
    if ( searchStr != nil && searchStr.length > 0 && ![_searchStr isEqualToString:searchStr]) {
        _searchStr = searchStr;
        
        self.searchPYStr = [NSString changeChineseToPinYin:_searchStr block:^(NSDictionary<NSNumber *,NSMutableArray *> *dict) {
            self.searchPYDict = dict;
        }];
    
    }
}

- (NSMutableArray <NSValue *> *)matching
{
    
    //获得 拼音首字母 匹配
    NSString * upLetterKey = [NSString changeChineseToPinYinFirstLetter:self.searchStr];
    NSString * upLetterTitle = [NSString changeChineseToPinYinFirstLetter:self.sourceStr];
    NSArray <NSValue *> * FirstLetterRanges = [upLetterTitle getAllRangeOfString:upLetterKey];
    
    //获得 全拼匹配
    NSArray <NSValue *> * AllPYRange =  [self.sourcePYStr getAllRangeOfString:self.searchPYStr];
    NSMutableArray <NSValue *> * RealAllPYRange = [NSMutableArray array];
    for (NSValue * rangeValue in AllPYRange) {
        NSRange PYRange = [rangeValue rangeValue];
        NSMutableArray * numbers = [NSMutableArray array];
        //把range转为数字数组
        for (NSUInteger j = PYRange.location; j < PYRange.location + PYRange.length; j ++) {
            [numbers addObject:@(j)];
        }
        NSMutableSet * sourcePYDictRangeKeys = [NSMutableSet set];
        for (NSNumber * key in [self.sourcePYDict allKeys]) {
            NSMutableArray * values = [self.sourcePYDict objectForKey:key];
            for (NSNumber * tmpB in numbers) {
                if ([values containsObject:tmpB]) {
                    [sourcePYDictRangeKeys addObject:key];
                }
            }
        }
        NSArray * realRangeArr = [sourcePYDictRangeKeys allObjects];
        realRangeArr = [realRangeArr sortedArrayUsingComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        NSUInteger location = [[realRangeArr firstObject] unsignedIntegerValue];
        NSUInteger length = [realRangeArr count];
        NSRange realRange = NSMakeRange(location, length);
        [RealAllPYRange addObject:[NSValue valueWithRange:realRange]];
    }
    NSMutableArray * resultRangeArr = [NSMutableArray arrayWithArray:FirstLetterRanges];
    [resultRangeArr addObjectsFromArray:RealAllPYRange];
    
    
    
    return resultRangeArr;

}


@end
