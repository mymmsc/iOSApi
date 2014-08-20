//
//  NSString+Utils.h
//  iOSApi
//
//  Created by WangFeng on 11-11-1.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>

/********************< NSString类扩展 >********************/
@interface NSString (Utils)

// 正则表达式匹配
- (BOOL)match:(NSString *)regex;

// 去掉左右两边的空白
- (NSString *)trim;

+ (NSString *)valueOf:(int)n;

// 比较字符串是否相同, 忽略大小写
- (BOOL)isSame:(NSString *)s;

// 替换字符串
- (NSString *)replace:(NSString *)search withString:(NSString *)string;

// 分割字符串
- (NSArray *)split:(NSString *)string;

// 返回URI请求参数的字典
- (NSDictionary *)uriParams;

/**
 * 字符串第一个字母变成大写, 其它不变
 */
- (NSString *)firstUpper;

// 繁体转简体
- (NSString *)toSimple;

// 简体转繁体
- (NSString*)toTrad;

@end
