//
//  iOSApi+Reflex.m
//  iOSApi
//
//  Created by wangfeng on 12-6-24.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSApi+Reflex.h"
#import "NSObject+Utils.h"
#import "NSString+Utils.h"

@implementation iOSApi (Reflex)

+ (NSString *)toString:(id)obj class:(api_type_t)type{
    NSString *sRet = nil;
    NSNumber *number = nil;
    switch (type) {
        case class_bool:
            if ([obj isKindOfClass:NSNumber.class]) {
                number = (NSNumber *)obj;
            } else {
                number = [NSNumber numberWithBool:(BOOL)obj];
            }
            if ([number boolValue]) {
                sRet = @"true";
            } else {
                sRet = @"false";
            }            
            break;
        case class_short:
            if ([obj isKindOfClass:NSNumber.class]) {
                number = (NSNumber *)obj;
            } else {
                number = [NSNumber numberWithShort:(short)obj];
            }
            sRet = [number stringValue];
            break;
        case class_int:
            if ([obj isKindOfClass:NSNumber.class]) {
                number = (NSNumber *)obj;
            } else {
                number = [NSNumber numberWithInt:(int)obj];
            }
            sRet = [number stringValue];
            break;
        case class_float:
            if ([obj isKindOfClass:NSNumber.class]) {
                number = (NSNumber *)obj;
            } else {
                number = [NSNumber numberWithFloat:0.00f];
            }
            sRet = [number stringValue];
            break;
        case class_long:
            if ([obj isKindOfClass:NSNumber.class]) {
                number = (NSNumber *)obj;
            } else {
                number = [NSNumber numberWithLong:(long)obj];
            }
            sRet = [number stringValue];
            break;
        case class_longlong:
            if ([obj isKindOfClass:NSNumber.class]) {
                number = (NSNumber *)obj;
            } else {
                number = [NSNumber numberWithLongLong:(long long)obj];
            }
            sRet = [number stringValue];
            break;
        case class_double:
            if ([obj isKindOfClass:NSNumber.class]) {
                number = (NSNumber *)obj;
            } else {
                number = [NSNumber numberWithFloat:0.00f];
            }
            sRet = [number stringValue];
            break;
        default:
            if ((Class)type == NSString.class) {
                sRet = obj;
            } else {
                sRet = @"";
            }
            break;
    }
    return sRet;
}

+ (id)classOf:(objc_property_t)property{
    id ret = nil;
    const char *attr = property_getAttributes(property);
    if (strcasestr(attr, "Ti,N,V")) {
        // int 类型
        ret = (id)class_int;
    } else if(strcasestr(attr, "Tc,N,V")) {
        // BOOL 类型
        ret = (id)class_bool;
    } else if(strcasestr(attr, "Tf,N,V")) {
        // float 类型
        ret = (id)class_float;
    } else if(strcasestr(attr, "Td,N,V")) {
        // double 类型
        ret = (id)class_double;
    } else if(strcasestr(attr, "Tl,N,V")) {
        // long 类型
        ret = (id)class_long;
    } else if(strcasestr(attr, "Tq,N,V")) {
        // long long 类型
        ret = (id)class_longlong;
    } else {
        // 默认为id类型
        char ct[1024];
        memset(ct, 0x00, sizeof(ct));
        sscanf(attr, "T@\"%[^\"]\"", ct);
        ret = NSClassFromString([NSString stringWithCString:ct encoding:NSUTF8StringEncoding]);
    }
    return ret;
}

+ (id)classOf:(Class)clazz
        field:(NSString *)field{
    id ret = nil;
    unsigned int outCount, i = 0;
    objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *fieldName = [NSString stringWithUTF8String: property_getName(property)];
        if ([field isSame:fieldName]) {
            ret = [self classOf:property];
            break;
        }
    }
    free(properties);
    properties = NULL;
    
    return ret;
}

+ (NSString *)fieldOf:(Class)clazz
                field:(NSString *)field{
    NSString *ret = nil;
    unsigned int outCount, i = 0;
    objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *fieldName = [NSString stringWithUTF8String: property_getName(property)];
        if ([field isSame:fieldName]) {
            ret = fieldName;
            break;
        }
    }
    free(properties);
    properties = NULL;
    
    return ret;
}

@end
