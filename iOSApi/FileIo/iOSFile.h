//
//  iOSFile.h
//  iOSApi
//
//  Created by wangfeng on 12-1-4.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>
//====================================< 文件操作类 >====================================
// iOSFile类操作文件都是相对路径

@interface iOSFile : NSObject {
    //
}
+ (NSFileManager *)manager;
+ (NSString *)path:(NSString *)filename;

// 文件是否存在
+ (BOOL)isExists:(NSString *)filename;

/**
 * 创建文件
 * @remark 默认都是在当前App根路径下操作, 所以filename参数只能是相对路径
 */
+ (NSFileHandle *)create:(NSString *)filename;

/**
 * 删除文件
 */
+ (BOOL)remove:(NSString *)filename;

//--------------------< 文件 - 属性 >--------------------

// 获得文件尺寸
+ (long long)fileSize:(NSString *)filename;

// 获得文件修改时间
+ (NSDate *)fileDate:(NSString *)filename;

// 修改文件创建时间(NSFileModificationDate)
+ (BOOL)setDate:(NSString *)filename date:(NSDate *)date;

@end
