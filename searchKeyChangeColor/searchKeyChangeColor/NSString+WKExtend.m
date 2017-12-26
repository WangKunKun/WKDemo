//
//  NSString+WKExtend.m
//  searchKeyChangeColor
//
//  Created by wangkun on 2017/12/26.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "NSString+WKExtend.h"

@implementation NSString (WKExtend)

- (NSArray *)getAllRangeOfString:(NSString *)searchString
{
    if (self.length <= 0 || !searchString || searchString.length <= 0) {
        return nil;
    }
    NSMutableArray * arr = [NSMutableArray array];
    NSString * newStr = [self copy];
    NSRange range = [newStr rangeOfString:searchString];
    [arr addObject:[NSValue valueWithRange:range]];
    while (range.location != NSNotFound) {
        NSInteger start = range.location + range.length;
        if (start >= self.length) {
            break;
        }
        newStr = [self substringFromIndex:start];
        range = [newStr rangeOfString:searchString];
        range.location += start;
        [arr addObject:[NSValue valueWithRange:range]];
        
    }
    return arr;
}


+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

+ (NSString *)changeChineseToPinYin:(NSString *)str block:(PYDictBlock)dictBlock
{
    if (str && str.length > 0 ) {
        //首先去掉空格
        NSCharacterSet * ignoreSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //去掉字符串中的所有特殊符号
        NSArray * strList = [str componentsSeparatedByCharactersInSet:ignoreSet];
        NSMutableString *trimmedString = [NSMutableString string];
        for (NSString * tmpStr in strList) {
            [trimmedString appendString:tmpStr];
        }
        
        NSMutableDictionary <NSNumber *,NSMutableArray *> * PYDict = [NSMutableDictionary dictionary];
        
        NSMutableString *result = [NSMutableString  string];
        for (int i=0; i<[trimmedString length]; i++)
        {
            NSString * tmpStr = [trimmedString substringWithRange:NSMakeRange(i, 1)];
            NSString * realStr = [tmpStr uppercaseString];
            if ([self IsChineseForString:tmpStr]) {
                realStr = [[self transform:tmpStr] uppercaseString];
            }
            [result appendString:realStr];
            
            //数组 从后往前匹配，防止有相同的拼音
            NSRange range = [result rangeOfString:realStr options:NSBackwardsSearch];
            NSMutableArray * indexArr = [NSMutableArray array];
            for (NSUInteger j = range.location; j < range.location + range.length; j ++) {
                [indexArr addObject:@(j)];
            }
            [PYDict setObject:indexArr forKey:@(i)];
        }
        
        if (dictBlock) {
            dictBlock(PYDict);
        }
        return result;
    }
    return nil;
}


+ (NSString *)changeChineseToPinYinFirstLetter:(NSString *)str
{
    if (str && str.length > 0 ) {
        
        NSMutableString *result = [NSMutableString  string];
        for (int i=0; i<[str length]; i++)
        {
            NSString * tmpStr = [str substringWithRange:NSMakeRange(i, 1)];
            if ([self IsChineseForString:tmpStr]) {
                NSString * firstLetter = [[[self transform:tmpStr] substringWithRange:NSMakeRange(0, 1)] uppercaseString];
                [result appendString:firstLetter];
            }
            else
            {
                [result appendString:[tmpStr uppercaseString]];
            }
        }
        return result;
    }
    return nil;
}

//只能穿一个字符的字符串进去
+ (BOOL)IsChineseForString:(NSString *)string
{
    int a = [string characterAtIndex:0];
    if (a < 0x9fff && a > 0x4e00)
    {
        return  YES;
    }
    return NO;
}

@end
