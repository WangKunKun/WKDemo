//
//  WKSearchStringManager.m
//  MKWeekly
//
//  Created by wangkun on 2017/12/26.
//  Copyright © 2017年 zymk. All rights reserved.
//

#import "WKSearchStringManager.h"
#import "NSString+WKExtend.h"
#define W_S __weak typeof(self) weakSelf = self;
@interface WKSearchStringManager ()

@property (nonatomic, strong) NSString * searchPYStr;
@property (nonatomic, strong) NSString * sourcePYStr;

@property (nonatomic, strong) NSDictionary <NSNumber *,NSMutableArray *> * searchPYDict;
@property (nonatomic, strong) NSDictionary <NSNumber *,NSMutableArray *> * sourcePYDict;


@property (nonatomic, strong) NSCache * strCache;
@property (nonatomic, strong) NSCache * dictCache;
@property (nonatomic, strong) NSCache * numberCache;

//如果搜索字符为纯中文 则不需要匹配首字母
@property (nonatomic, assign) BOOL  isMatchingFirstLetter;

@end


@implementation WKSearchStringManager

+ (instancetype)sharedSearchStringManager
{
    static WKSearchStringManager * wkssm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wkssm = [WKSearchStringManager new];
        wkssm.isMatchingFirstLetter = YES;
    });
    return wkssm;
}

- (NSCache *)strCache
{
    if (!_strCache) {
        _strCache = [[NSCache alloc] init];
    }
    return _strCache;
}

- (NSCache *)dictCache
{
    if (!_dictCache) {
        _dictCache = [[NSCache alloc] init];
    }
    return _dictCache;
}

- (NSCache *)numberCache
{
    if (!_numberCache) {
        _numberCache = [[NSCache alloc] init];
    }
    return _numberCache;
}

- (void)setSourceStr:(NSString *)sourceStr
{
    if ( sourceStr != nil && sourceStr.length > 0 && ![_sourceStr isEqualToString:sourceStr]) {
        _sourceStr = sourceStr;
        
        
        NSString * cacheSourcePYStr = [self.strCache objectForKey:_sourceStr];
        NSDictionary * cacheSourcePYDict = [self.dictCache objectForKey:_sourceStr];
        
        if (cacheSourcePYStr && cacheSourcePYDict) {
            self.sourcePYStr = cacheSourcePYStr;
            self.sourcePYDict = cacheSourcePYDict;
        }
        else
        {
            W_S
            self.sourcePYStr = [NSString changeChineseToPinYin:_sourceStr block:^(NSDictionary<NSNumber *,NSMutableArray *> *dict,BOOL isJustChinese) {
                weakSelf.sourcePYDict = dict;
            }];
        }
    }
}
- (void)setSearchStr:(NSString *)searchStr
{
    if ( searchStr != nil && searchStr.length > 0 && ![_searchStr isEqualToString:searchStr]) {
        _searchStr = searchStr;
        
        NSString * cacheSearchPYStr = [self.strCache objectForKey:_searchStr];
        NSDictionary * cacheSearchPYDict = [self.dictCache objectForKey:_searchStr];
        NSNumber * cacheSearchIsMattingFirstLetter = [self.numberCache objectForKey:_searchStr];
        if (cacheSearchPYStr && cacheSearchPYDict && cacheSearchIsMattingFirstLetter) {
            self.searchPYStr = cacheSearchPYStr;
            self.searchPYDict = cacheSearchPYDict;
            self.isMatchingFirstLetter = [cacheSearchIsMattingFirstLetter boolValue];
        }
        else
        {
            W_S
            self.searchPYStr = [NSString changeChineseToPinYin:_searchStr block:^(NSDictionary<NSNumber *,NSMutableArray *> *dict,BOOL isJustChinese) {
                weakSelf.searchPYDict = dict;
                weakSelf.isMatchingFirstLetter = !isJustChinese;
            }];
        }
    
    }
}

- (void)setSourcePYStr:(NSString *)sourcePYStr
{
    _sourcePYStr = sourcePYStr;
    [self.strCache setObject:_sourcePYStr forKey:_sourceStr];
}

-(void)setSearchPYStr:(NSString *)searchPYStr
{
    _searchPYStr = searchPYStr;
    [self.strCache setObject:_searchPYStr forKey:_searchStr];
}

- (void)setSearchPYDict:(NSDictionary<NSNumber *,NSMutableArray *> *)searchPYDict
{
    _searchPYDict = searchPYDict;
    [self.dictCache setObject:_searchPYDict forKey:_searchStr];
}

- (void)setSourcePYDict:(NSDictionary<NSNumber *,NSMutableArray *> *)sourcePYDict
{
    _sourcePYDict = sourcePYDict;
    [self.dictCache setObject:_sourcePYDict forKey:_sourceStr];
}

- (void)setIsMatchingFirstLetter:(BOOL)isMatchingFirstLetter
{
    _isMatchingFirstLetter = isMatchingFirstLetter;
    [self.numberCache setObject:@(isMatchingFirstLetter) forKey:_searchStr];
}

- (NSMutableArray <NSValue *> *)matching
{
    //拼音rangge
    NSArray <NSValue *> * AllPYRange =  [self.sourcePYStr getAllRangeOfString:self.searchPYStr];
    NSMutableArray <NSValue *> * RealAllPYRange = [NSMutableArray array];
    for (NSValue * rangeValue in AllPYRange) {
        NSRange PYRange = [rangeValue rangeValue];
        NSMutableArray * numbers = [NSMutableArray array];
        //把rangge转为数字数组
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
    NSMutableArray * resultRangeArr = [NSMutableArray arrayWithArray:RealAllPYRange];
    if (self.isMatchingFirstLetter) {
        NSString * upLetterKey = [NSString changeChineseToPinYinFirstLetter:self.searchStr];
        NSString * upLetterTitle = [NSString changeChineseToPinYinFirstLetter:self.sourceStr];
        NSArray <NSValue *> * FirstLetterRanges = [upLetterTitle getAllRangeOfString:upLetterKey];
        [resultRangeArr addObjectsFromArray:FirstLetterRanges];
    }
    return resultRangeArr;

}


@end
