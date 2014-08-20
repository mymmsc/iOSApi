//
//  main.m
//  iOSApiTest
//
//  Created by wangfeng on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
typedef enum api_type_t{
class_unknown=0, // NSObject
class_bool, // BOOL
class_byte, // byte
class_short, // short
class_int, // int
class_float, // float
class_long, // long
class_longlong, // long long
class_double, // double
} api_type_t;;

@interface Abc : NSObject
@property (nonatomic, assign) int a;
@end

@implementation Abc

@synthesize a;

@end
@interface Test : NSObject

@property (nonatomic, assign) float price;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) BOOL isOpned;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSMutableArray *list1;
@property (nonatomic, retain) NSDictionary *map;
@property (nonatomic, retain) NSMutableDictionary *map1;
@property (nonatomic, retain) Abc *aaa;

@end

@implementation Test

@synthesize status, list, message, map, map1, list1, aaa;
@synthesize price, isSend, isOpned;

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

+ (NSString *)listString:(NSArray *)array toLower:(BOOL)toLower{
    NSMutableString *buff = [NSMutableString stringWithCapacity:0];
    int count = array.count;
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

int main(int argc, const char * argv[])
{
    @autoreleasepool {        
        // insert code here...
        NSLog(@"Hello, World!");
        Test *obj = [[Test alloc] init];
        obj.price = 0.01f;
        obj.status = 901;
        obj.isSend = YES;
        obj.isOpned = NO;
        obj.message = @"wokao 中国";
        NSLog(@"json = [%@]", [Test jsonString:obj toLower:NO]);
        id t = [Test classOf:obj field:@"status"];
        [obj release];
        obj = nil;
        NSString * tmp = @"CARD:N:陳振生;TIL:;DIV:董;事;長;室; ; ;COR:捷達威數位科技股份有限公司;TEL:82261298-127;FAX:82261308;EM:jason@jsdway.com.tw;URL:http://www.jcard.com.tw;ADR:新北市中和區建八路2號15樓-5;NOTE:LOG:pyEqnauY5yP60hEhm1YQnjNkPW0OPzu15HEhUjYkFhFM5HThIy-b5HThIgwO5HThmv9qnauViy3qnT;;;";
        
        //    NSRange r;
        NSString *regExStr = @"(([^:]+):(([^;]*)([^a-zA-Z:]*));)";
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        
        
        __block NSMutableArray  * timeTimes = [NSMutableArray array];
        [regex enumerateMatchesInString:tmp options:0 range:NSMakeRange(0, [tmp length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSLog(@"0.timeTimes = %@",[tmp substringWithRange:[result rangeAtIndex:0]]);
            NSLog(@"1.timeTimes = %@",[tmp substringWithRange:[result rangeAtIndex:1]]);
            NSLog(@"2.timeTimes = %@",[tmp substringWithRange:[result rangeAtIndex:2]]);
            NSLog(@"3.timeTimes = %@",[tmp substringWithRange:[result rangeAtIndex:3]]);
            [timeTimes addObject:[tmp substringWithRange:[result rangeAtIndex:1]]];
        }];
    }
    return 0;
}

