//
//  iOSApi+Crypto.m
//  iOSApi
//
//  Created by wangfeng on 12-1-3.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSApi+Crypto.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSString+Utils.h"
//====================================< 编码/安全 - 接口 >====================================
@implementation iOSApi (Crypto)

//--------------------< 编码/安全 - 接口 - BASE64 >--------------------

//--------------------< 接口 - 对象 - BASE64 >--------------------
#include "api_base64.h"

+ (NSString *)base64sEncode:(NSString *)input {
    NSString *sRet = nil;
    const char *s = [input UTF8String];
    
    int s_len = (int)[input length];
    
    //转换到base64
    char *dst = (char *)malloc(s_len * 4);
    memset(dst, 0x00, s_len * 4);
    api_base64_encode_binary(dst, (const unsigned char *)s, s_len);
    sRet = [NSString stringWithCString:dst encoding:NSUTF8StringEncoding]; 
    free(dst);
    dst = NULL;
    
    return sRet; 
}

+ (NSData *)base64Decode:(NSString *)input {
    NSData *dRet = nil;
    const char *s = [input UTF8String];
    int s_len = (int)[input length];
    unsigned char *dst = (unsigned char *)malloc(s_len);
    memset(dst, 0x00, s_len);
    
    int d_len = api_base64_decode_binary(dst, s);
    
    dRet = [NSData dataWithBytes:dst length:d_len];
    
    free(dst);
    dst = NULL;
    return dRet;
}

+ (NSString *)base64sDecode:(NSString *)input{
    NSData *data = [self base64Decode:input];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

//--------------------< 编码/安全 - 接口 - URL >--------------------
+ (NSString *)urlDecode:(NSString *)url{
    NSString *result = [[url stringByReplacingOccurrencesOfString:@"+" withString:@" "] trim];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (result == nil) {
        result = url;
    }
    return result;
}

+ (NSString *)urlEncode:(NSString *)url{
    NSString *result = [[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] trim];
    if (result == nil) {
        result = url;
    }
    return result;
}

@end
