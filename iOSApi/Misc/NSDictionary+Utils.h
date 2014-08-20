//
//  NSDictionary+Utils.h
//  iOSApi
//
//  Created by wangfeng on 12-3-10.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

// 字典key/value填充对象
- (BOOL)fillObject:(id)obj;

// 字典转换对象
- (id)toObject:(Class)clazz;

@end
