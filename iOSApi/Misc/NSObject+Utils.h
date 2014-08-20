//
//  NSObject+Utils.h
//  iOSApi
//
//  Created by WangFeng on 11-12-27.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>

@interface NSObject (Utils)

/**
 * 对象赋值, 忽略字段名大小写
 */
- (BOOL)setValue:(id)value forSameKey:(NSString *)key;
- (BOOL)setField:(id)value forKey:(NSString *)key;

@end
