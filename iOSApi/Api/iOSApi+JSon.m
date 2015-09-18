//
//  iOSApi+JSon.m
//  iOSApi
//
//  Created by wangfeng on 12-6-23.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSApi+JSon.h"
#import "iOSApi+Reflex.h"
#import "JSONKit.h"
#import "NSObject+Utils.h"
#import "NSString+Utils.h"
#import <objc/runtime.h>

@implementation iOSApi (JSon)

// 数组赋值
+ (NSMutableArray *)assignArray:(NSArray *)array class:(Class)clazz{
    NSMutableArray *aRet = nil;
    if (array != nil) {
        for (int i = 0; i < array.count; i++) {
            id value = [array objectAtIndex:i];
            if ([value isKindOfClass:NSDictionary.class]) {
                id obj = [self assignObject:value class:clazz];
                if (obj != nil) {
                    if (aRet == nil) {
                        aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
                    }
                    [aRet addObject:obj];
                }
            }
        }
    }
    return aRet;
}

// 对象赋值
+ (id)assignObject:(NSDictionary *)dict class:(Class)clazz{
    id oRet = nil;
    BOOL bAssigned = NO;
    for (NSString *key in [dict allKeys]) {
        NSString *newkey = [key trim];
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:NSNull.class]) {
            continue;
        }
        if (oRet == nil) {
            oRet = [[clazz alloc] init];
        }
        if ([value isKindOfClass:NSDictionary.class]) {
            Class clz = [iOSApi classOf:clazz field:newkey];
            // 对象里面套对象
            id obj = [self assignObject:value class:clz];
            if (obj != nil) {
                if ([iOSApi setObject:oRet key:newkey value:obj]) {
                    bAssigned = YES;
                }
            }
        } else if ([value isKindOfClass:NSArray.class]) {
            // 对象里面有数组, 数组的类型按照属性Class来获取
            NSString *fieldName = [iOSApi fieldOf:clazz field:newkey];
            NSString *selName = [NSString stringWithFormat:@"%@Class", fieldName];
            SEL aSel = NSSelectorFromString(selName);
            if ([oRet respondsToSelector:aSel]) {
                IMP func = [oRet methodForSelector:aSel];
                Class subClass = func(oRet, aSel);
                id obj = [self assignArray:value class:subClass];
                if (obj != nil) {
                    if ([oRet setValue:obj forSameKey:fieldName]) {
                        bAssigned = YES;
                    }
                }
            }
        } else {
            // 基本数据类型
            if ([oRet setValue:value forSameKey:newkey]) {
                bAssigned = YES;
            }
        }
    }
    if (oRet != nil) {
        if (!bAssigned) {
            IOSAPI_RELEASE(oRet);
        } else {
            oRet = [oRet autorelease];
        }
    }
    return oRet;
}

// 解析JSON串, 并封装成对象
+ (id)parse:(NSString *)string class:(Class)clazz{
    id oRet = nil;
    if (string == nil || clazz == nil) {
        // 如果string或class为NULL, 则直接返回nil
    } else {
        id orig = [string objectFromJSONString];
        if (orig != nil && [orig isKindOfClass:NSDictionary.class]) {
            oRet = [self assignObject:orig class:clazz];
        }
    }
    
    return oRet;
}

+ (NSString *)listString:(NSArray *)array toLower:(BOOL)toLower{
    NSMutableString *buff = [NSMutableString stringWithCapacity:0];
    int count = (int)array.count;
    for (int i = 0; i < count; i++) {
        id obj = [array objectAtIndex:i];
        NSString *value = [self jsonString:obj toLower:YES];
        if (value != nil) {
            [buff appendString:value];
        }
        if (i + 1 < count) {
            [buff appendString:@","];
        }
    }
    return [buff autorelease];
}

+ (NSString *)jsonString:(id)object toLower:(BOOL)toLower{
    NSMutableString *buff = [NSMutableString stringWithCapacity:0];
    if (object != nil) {
        [buff appendString:@"{"];
        Class clazz = [object class];
        while (clazz != [NSObject class]) {
            unsigned int outCount, i = 0;
            objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
            NSString *key = nil;
            for (i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                if (property != NULL) {
                    NSString *fieldName = [NSString stringWithUTF8String:property_getName(property)];
                    id type = [self classOf:property];
                    key = fieldName;
                    [buff appendFormat:@"\"%@\":", toLower ? [key lowercaseString]:key];
                    SEL aSel = NSSelectorFromString(fieldName);
                    if ([object respondsToSelector:aSel]) {
                        id value = [object valueForKey:fieldName];
                        //IMP func = [object methodForSelector:aSel];
                        //id value = func(object, aSel);
                        //Class class = [value class];
                        //NSNumber *number = (NSNumber *)value;
                        NSString *str = nil;
                        if ((api_type_t)type <= class_double) {
                            str = [self toString:value class:(api_type_t)type];
                            [buff appendString:str];
                        } else if((Class)type == NSArray.class || [value isKindOfClass:NSArray.class]) {
                            [buff appendString:@"["];
                            str = [self jsonString:(NSArray *)value toLower:toLower];
                            if (str != nil) {
                                [buff appendString:str];
                            }
                            [buff appendString:@"]"];
                        } else if ([value isKindOfClass:NSString.class]) {
                            str = (NSString *)value;
                            if (str == nil || [str isKindOfClass:NSNull.class]) {
                                str = @"";
                            }
                            //value = [value replace:@"\"" withString:@"\\\""];
                            [buff appendFormat:@"\"%@\"", str];
                        } else  if ([(Class)type superclass] == NSObject.class ||[value isKindOfClass:NSObject.class]){
                            value = [self jsonString:(NSObject *)value toLower:toLower];
                            str = (NSString *)value;
                            if (str != nil && str.length > 0) {
                                [buff appendString:str];
                            } else {
                                [buff appendString:@"{}"];
                            }
                        }
                    }
                    if (i + 1 < outCount) {
                        [buff appendFormat:@","];
                    }
                }
            }
            free(properties);
            properties = NULL;
            clazz = [clazz superclass];
        }
        [buff appendString:@"}"];
    }
    
    return buff;
}

@end
