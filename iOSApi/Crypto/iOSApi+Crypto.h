//
//  iOSApi+Crypto.h
//  iOSApi
//
//  Created by wangfeng on 12-1-3.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSApi.h"

//====================================< 编码/安全 - 接口 >====================================
@interface iOSApi (Crypto)

//--------------------< 编码/安全 - 接口 - BASE64 >--------------------

// base64字符串编码
+ (NSString *)base64sEncode:(NSString *)input;
// base64流解码
+ (NSData *)base64Decode:(NSString *)input;
// base64字符串解码
+ (NSString *)base64sDecode:(NSString *)input;

//--------------------< 编码/安全 - 接口 - URL >--------------------

+ (NSString *)urlDecode:(NSString *)url;
+ (NSString *)urlEncode:(NSString *)url;

@end
