//
//  iOSFile.m
//  iOSApi
//
//  Created by wangfeng on 12-1-4.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSFile.h"

@implementation iOSFile

+ (NSFileManager *)manager{
    return [NSFileManager defaultManager];
}

+ (NSString *)path:(NSString *)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSFileManager *fm = [self manager];
    NSString *path = @"";
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *tmpPaths = [filename componentsSeparatedByString:@"/"];
    int count = tmpPaths.count;
    if (count > 1) {
        // 检查目录
        path = [NSString stringWithFormat:@"%@/%@", documentsDirectory, [[tmpPaths subarrayWithRange:NSMakeRange(0, count -1)] componentsJoinedByString:@"/"]];
        BOOL isDir = YES;
        if(![fm fileExistsAtPath: path isDirectory: &isDir]){
            [iOSApi mkdirs: path];
        }
    }
    return [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
}

+ (BOOL)isExists:(NSString *)filename{
    NSString *filepath = [iOSFile path:filename];
    BOOL bExists = NO;
    bExists = [[iOSFile manager] fileExistsAtPath:filepath];
    return bExists;
}

/**
 * 创建文件
 * @remark 默认都是在当前App根路径下操作, 所以filename参数只能是相对路径
 */
+ (NSFileHandle *)create:(NSString *)filename {
    NSFileHandle *fileHandle = nil;
    NSString *filePath = [self path:filename];
    // 创建一个空文件
    BOOL bCreate = [[self manager] createFileAtPath:filePath contents:nil attributes:nil];
    if (bCreate) {
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    }
    
    return fileHandle;
}

/**
 * 删除文件
 */
+ (BOOL)remove:(NSString *)filename {
    NSString *filePath = [self path:filename];
    NSFileManager *mgr = [self manager];
    NSError *error = nil;
    
    BOOL bRet = [mgr removeItemAtPath:filePath error:&error];
    if (!bRet && error != nil) {
        // 异常
        iOSLog(@"删除文件[%@] 异常: [%d]%@", filename, [error code], [error localizedDescription]);
    }
    
    return bRet;
}

//--------------------< 文件 - 属性 >--------------------

+ (NSDictionary *)fileAttr:(NSString *)filename {
    NSFileManager *fileManager = [self manager];
    NSDictionary *fileAttributes;
    NSError *error = nil;
    //NSDictionary是一个数据结构，其中包括：文件大小，创建日期，修改日期
    //由于只是读数据，则不用可变的NSMutableDictionary
    fileAttributes = [fileManager attributesOfItemAtPath:filename error:&error];
    if (error != nil) {
        // 异常
        iOSLog(@"读取文件[%@]属性 异常: [%d]%@", filename, [error code], [error localizedDescription]);
    }
    return fileAttributes;
}

// 获得文件尺寸NSFileSize
+ (long long)fileSize:(NSString *)filename {
    long long iRet = 0;
    NSDictionary *fileAttributes = [self fileAttr:filename];
    if (fileAttributes.count > 0) {
        NSNumber *fileSize= [fileAttributes objectForKey:NSFileSize];
        iRet = [fileSize longLongValue];
    }
    
    return iRet;
}

// 获得文件修改时间NSFileModificationDate
+ (NSDate *)fileDate:(NSString *)filename {
    NSDate *ret = nil;
    NSString *filePath = [self path:filename];
    NSDictionary *fileAttributes = [self fileAttr:filePath];
    if (fileAttributes.count > 0) {
        ret = [fileAttributes objectForKey:NSFileModificationDate];
    }
    
    return ret;
}

// 修改文件创建时间(NSFileModificationDate)
+ (BOOL)setDate:(NSString *)filename date:(NSDate *)date{
    BOOL bRet = NO;
    NSString *filePath = [self path:filename];
    NSFileManager *fileManager = [self manager];
    NSError *error = nil;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:date,NSFileModificationDate, nil];
    
    bRet = [fileManager setAttributes:attributes ofItemAtPath:filePath error:&error];
    if (!bRet) {
        // 异常
        iOSLog(@"修改文件[%@]最后修改日期异常: [%d]%@", filename, [error code], [error localizedDescription]);
    }
    return bRet;
}

@end
