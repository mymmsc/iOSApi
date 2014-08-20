//
//  iOSApi+Reflex.h
//  iOSApi
//
//  Created by wangfeng on 12-6-24.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSApi.h"
#import <objc/runtime.h>

typedef enum api_type_t{
    class_unknown, // NSObject
    class_bool, // BOOL
    class_byte, // byte
    class_short, // short
    class_int, // int
    class_float, // float
    class_long, // long
    class_longlong, // long long
    class_double, // double
} api_type_t;

@interface iOSApi (Reflex)

+ (NSString *)toString:(id)obj class:(api_type_t)type;

+ (id)classOf:(objc_property_t)property;

// 获取字段类型
+ (id)classOf:(Class)clazz
        field:(NSString *)field;

// 修订字段名称
+ (NSString *)fieldOf:(Class)clazz
                field:(NSString *)field;

@end
