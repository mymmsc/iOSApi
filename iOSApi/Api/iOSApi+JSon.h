//
//  iOSApi+JSon.h
//  iOSApi
//
//  Created by wangfeng on 12-6-23.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSApi.h"

@interface iOSApi (JSon)

// 数组赋值
+ (NSMutableArray *)assignArray:(NSArray *)array class:(Class)clazz;
// 对象赋值
+ (id)assignObject:(NSDictionary *)dict class:(Class)clazz;
// 解析JSON串, 并封装成对象
+ (id)parse:(NSString *)string class:(Class)clazz;

// 输出JSON串
+ (NSString *)jsonString:(id)object toLower:(BOOL)toLower;

@end
