//
//  iOSCache.m
//  iOSApi
//
//  Created by wangfeng on 12-1-1.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSCache.h"

@implementation iOSCache

// url本地cache相对于文档路径的的文件名, 根据url连接小写的字符串计算md5所得
+ (NSString *)cacheAsUrl:(NSString *)url{
    NSString *tmpUrl = url;
    if (tmpUrl == nil) {
        tmpUrl = @"";
    } else {
        tmpUrl = [tmpUrl lowercaseString];
    }
    NSString *tmpMD5 = [iOSApi md5:tmpUrl];
    return [NSString stringWithFormat:@"%@/%@.tmp", IOS_CACHE_ROOT, tmpMD5];
}

@end
