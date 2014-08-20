//
//  iOSCache.h
//  iOSApi
//
//  Created by wangfeng on 12-1-1.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>
//====================================< 缓冲机制 - 接口 >====================================
// 支持iTunes文件共享, info.plist增加 Application supports iTunes file sharing=YES

#define IOS_DATA_ROOT     @"data"       // 数据根路径
#define IOS_DATA_DATABASE @"data/db"    // 数据库根路径
#define IOS_CACHE_ROOT    @"data/cache" // 临时缓冲文件路径
#define IOS_FILE_ROOT     @"data/files" // 数据文件根路径
#define IOS_CACHE_TEMP    @"data/temp"  // 临时缓冲区根路径

// 文件缓冲
@interface iOSCache : NSObject {
    //
}

// url本地cache相对于文档路径的的文件名, 根据url连接小写的字符串计算md5所得
+ (NSString *)cacheAsUrl:(NSString *)url;

@end
