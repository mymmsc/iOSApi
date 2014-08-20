//
//  NSDictionary+Utils.m
//  iOSApi
//
//  Created by wangfeng on 12-3-10.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "NSDictionary+Utils.h"
#import "NSObject+Utils.h"
#import "NSString+Utils.h"

@implementation NSDictionary (Utils)

// 字典key/value填充对象
- (BOOL)fillObject:(id)obj{
    BOOL bRet = NO;
    for (NSString *key in [self allKeys]) {
        NSString *newkey = [key trim];
        id value = [self objectForKey:key];
        if ([value isKindOfClass:NSNull.class]) {
            continue;
        }
        //iOSLog(@"key = [%@], value = [%@]", key, value);
        if([obj setValue:value forSameKey:newkey]) {
            bRet = YES;
        }
    }
    return bRet;
}

// 字典转换对象
- (id)toObject:(Class)clazz{
    id obj = nil;
    if (self.count > 0) {
        id tmp = [[clazz alloc] init];
        if ([self fillObject:tmp]) {
            obj = [tmp autorelease];
        } else {
            [tmp release];
            tmp = nil;
        }
    }
    
    return obj;
}

@end
