//
//  iOSApi.m
//  iOSApi
//
//  Created by WangFeng on 11-12-18.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>
#import <iOSApi/NSString+Utils.h>
#import <iOSApi/iOSApi+Crypto.h>
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

#include <stdlib.h>
#include <stdio.h>
#include <time.h> // for time_t
#include <regex.h>

//====================================< 通用 - 接口 >====================================
@implementation iOSApi

//--------------------< 通用 - 接口 - 应用程序相关 >--------------------

// 关闭应用程序
+ (void)AppClose{
	exit(0);
}

// 获取当前应用程序的版本号
+ (NSString *)version {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithContentsOfFile: plistPath] autorelease];
	return [dict objectForKey: @"CFBundleShortVersionString"];
}

// ipa版本号和version参数比较, 是否需要更新
+ (BOOL)isNeedUpload:(NSString *)version{
    BOOL bRet = NO;
    if (version != nil) {
        int vApp = 0, vSrv = 0;
        NSArray *cur = [[self version] componentsSeparatedByString:@"."];
        NSArray *list = [version componentsSeparatedByString:@"."];
        int i = 0;
        for (i = 0; cur.count > i && list.count > i; i++) {
            vApp = [[cur objectAtIndex:i] intValue];
            vSrv = [[list objectAtIndex:i] intValue];
            if (vApp < vSrv) {
                bRet = YES;
                break;
            } else if (vApp > vSrv) {
                break;
            }
        }
    }
    return bRet;
}

//--------------------< 通用 - 接口 - 标准用户缓存信息 >--------------------
+ (NSUserDefaults *)cache{
    return [NSUserDefaults standardUserDefaults];
}

+ (NSString *)objectForCache:(NSString *)key {
	NSUserDefaults *info = [self cache];
    return [info objectForKey: key];
}

+ (void)cacheSetObject:(NSString *)key
				 value:(NSString *)value {
	NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setObject: value forKey: key];
}

//--------------------< 通用 - 接口 - 类反射 >--------------------

+ (id)objectFrom:(NSString *)clazz {
    return [[[NSClassFromString(clazz) alloc] init] autorelease];    
}

// 基本类型相互转换
// 范围int,long,float,NSString
+ (id)valueOf_OLD:(id)value toType:(NSString *)toType{
    id iRet = nil;
    if ([toType compare:@"NSString"] == NSOrderedSame) {
        iRet = [NSString stringWithFormat:@"%@",value];
    } else {
        if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
            SEL aSel = NSSelectorFromString([NSString stringWithFormat:@"%@Value", toType]);
            if ([value respondsToSelector:aSel]) {
                IMP func = [value methodForSelector:aSel];
                iRet = func(value, aSel);
            }
        }
    }
    return iRet;
}

// 对象字段赋值
+ (BOOL)setObject:(NSObject *)obj
         property:(objc_property_t)property
            value:(id)value {
    BOOL bRet = NO;
    if (property != NULL) {
        const char *attr = property_getAttributes(property);
        NSString *field = [NSString stringWithUTF8String: property_getName(property)];
        NSString *selName = [NSString stringWithFormat:@"set%@:", [field firstUpper]];
        SEL aSel = NSSelectorFromString(selName);
        if (strcasestr(attr, "Ti,N,V")) {
            // int 类型
            int iVal = -1;
            if ([value isKindOfClass:[NSNumber class]]) {
                iVal = ((NSNumber *)value).intValue;
            } else if ([value isKindOfClass:[NSString class]]) {
                iVal = ((NSString *)value).intValue;
            }
            if ([obj respondsToSelector:aSel]) {
                IMP func = [obj methodForSelector:aSel];
                func(obj, aSel, iVal);
            }
        } else if(strcasestr(attr, "Tc,N,V")) {
            // BOOL 类型
            BOOL bVal = NO;
            if ([value isKindOfClass:[NSNumber class]]) {
                bVal = ((NSNumber *)value).boolValue;
            } else if ([value isKindOfClass:[NSString class]]) {
                bVal = ((NSString *)value).boolValue;
            }
            if ([obj respondsToSelector:aSel]) {
                IMP func = [obj methodForSelector:aSel];
                func(obj, aSel, bVal);
            }
        } else if(strcasestr(attr, "Tf,N,V")) {
            // float 类型
            float fVal = 0.00f;
            if ([value isKindOfClass:[NSNumber class]]) {
                fVal = ((NSNumber *)value).floatValue;
            } else if ([value isKindOfClass:[NSString class]]) {
                fVal = ((NSString *)value).floatValue;
            }
            if ([obj respondsToSelector:aSel]) {
                NSNumber *n = [NSNumber numberWithFloat:fVal];
                [obj setValue:n forKey:field];
            }
        } else if(strcasestr(attr, "Td,N,V")) {
            // double 类型
            double dVal = 0.00f;
            if ([value isKindOfClass:[NSNumber class]]) {
                dVal = ((NSNumber *)value).doubleValue;
            } else if ([value isKindOfClass:[NSString class]]) {
                dVal = ((NSString *)value).doubleValue;
            }
            if ([obj respondsToSelector:aSel]) {
                IMP func = [obj methodForSelector:aSel];
                func(obj, aSel, dVal);
            }
        } else if(strcasestr(attr, "Tl,N,V")) {
            // long 类型
            long lVal = 0;
            if ([value isKindOfClass:[NSNumber class]]) {
                lVal = ((NSNumber *)value).longValue;
            } else if ([value isKindOfClass:[NSString class]]) {
                // NSString 类型没有longValue
                iOSLog(@"warn: NSString not longValue.");
                lVal = (long)((NSString *)value).longLongValue;
            }
            if ([obj respondsToSelector:aSel]) {
                IMP func = [obj methodForSelector:aSel];
                func(obj, aSel, lVal);
            }
        } else if(strcasestr(attr, "Tq,N,V")) {
            // long long 类型
            long long llVal = 0;
            if ([value isKindOfClass:[NSNumber class]]) {
                llVal = ((NSNumber *)value).longLongValue;
            } else if ([value isKindOfClass:[NSString class]]) {
                llVal = ((NSString *)value).longLongValue;
            }
            if ([obj respondsToSelector:aSel]) {
                IMP func = [obj methodForSelector:aSel];
                func(obj, aSel, llVal);
            }
        } else if (strcasestr(attr, "T@\"NSString\"") && [value isKindOfClass:NSNumber.class]) {
            // NSString 类型, 传入值是NSNumber的
            NSString *sVal = [((NSNumber *)value) stringValue];
            if ([obj respondsToSelector:aSel]) {
                IMP func = [obj methodForSelector:aSel];
                func(obj, aSel, sVal);
            }
        } else if (strcasestr(attr, "T@\"NSString\"") && [value isKindOfClass:NSString.class]) {
            // NSString 类型, 两边一致
            // 除基本数据类型外, 如果是字符类型, 进行解码
            //NSString *sVal = [iOSApi urlDecode:value];
            //[obj setValue:sVal forKey:field];
            [obj setValue:value forKey:field];
        } else {
            // 默认为id类型
            iOSLog(@"warn: attr = [%s], 类型未知.", attr);
            [obj setValue:value forKey:field];
        }
        bRet = YES;
    }
    
    return bRet;
}

+ (BOOL)setObject:(NSObject *)obj
              key:(NSString *)key
            value:(id)value {
    BOOL bRet = NO;
    unsigned int outCount, i = 0;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *fieldName = [NSString stringWithUTF8String: property_getName(property)];
        if ([key isSame:fieldName]) {
            bRet = [self setObject:obj property:property value:value];
            break;
        }
    }
    free(properties);
    properties = NULL;
    return bRet;
}

//--------------------< 通用 - 接口 - 编码 >--------------------

+ (NSString *)createUUID {    
	// Create universally unique identifier (object)  
	CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);  
	// Get the string representation of CFUUID object.  
	NSString *uuidStr = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject); 
    //[uuidObject release];
	CFRelease(uuidObject);
	
	return [uuidStr autorelease];
} 

//--------------------< 通用 - 接口 - 随机数相关 >--------------------

//產生任意範圍的隨機數
//要產生0 ~ 99 的隨機數：rand() % 100
//要產生0 ~ N-1 的隨機數：rand() % N
//要產生a ~ b 的隨機數：a + (rand() % (b-a+1))
//所以要產生1 ~ 6 的隨機數：(可以用來模擬骰子的投擲點數)
//1 + (rand() % (6-1+1)) => 1 + (rand() % 6)

+ (void)randomize
{
    time_t t;
    srand((unsigned) time(&t));
}

 // return the value between 0 ~ N-1
+ (int)random:(int)max
{
    return (rand() % max);
}

+ (NSString *)o3String:(int)length {
    static char O3CHARS[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    //static char O3CHARS_EXT[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_ []{}<>~`+=,.;:/?|";
    [self randomize];
    char temp[1025];
    int max = strlen(O3CHARS);
    if (length > 1024) {
        length = 1024;
    }
    memset(temp, 0x00, sizeof(temp));
    for (int i = 0; i < length; i++) {
        temp[i] = O3CHARS[[self random:max]]; 
    }
    
    return [NSString stringWithCString:temp encoding:NSUTF8StringEncoding];
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];  
}

//--------------------< 通用 - 接口 - 文件系统 >--------------------

+ (BOOL)mkdirs:(NSString *)path {
	BOOL bRet = NO;
	NSError *error = nil; 
	BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path  
											 withIntermediateDirectories:YES  
															  attributes:nil  
																   error:&error]; 
	if (!success || error) { 
        //NSLog(@"Error! %@", error); 
	} else { 
        //NSLog(@"Success!");
		bRet = YES;
	}
	return bRet;
}

/**
 * 获取当前文档路径
 */
+ (NSString *)mainPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//--------------------< 通用 - 接口 - 正则表达式 >--------------------

+ (BOOL)regexpMatch:(NSString *)string withPattern:(NSString *)pattern {
    regex_t reg;
    regmatch_t sub[10];
    if (string == nil || string.length == 0 || pattern == nil || pattern.length == 0) {
        return NO;
    }
    int status = regcomp(&reg, [pattern UTF8String], REG_EXTENDED);
    if(status) {
        return NO;
    }
    status = regexec(&reg, [string UTF8String], 10, sub, 0);
    if(status == REG_NOMATCH) {
        return NO;
    } else if(status) {
        return NO;
    }
    
    return YES;
}

//--------------------< 通用 - 接口 - 验证 >--------------------
// 判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)string{
    BOOL bRet = YES;
    if (string != nil) {
        NSString *str = [string trim];
        if (str.length > 0) {
            bRet = NO;
        }
    }
    return bRet;
}

@end
/*--------------------< iOSApi class END >--------------------*/
