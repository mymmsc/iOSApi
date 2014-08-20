//
//  iOSDatabase.m
//  iOSApi
//
//  Created by wangfeng on 12-5-13.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSDatabase.h"
#import "iOSCache.h"
#import "iOSFile.h"
#include <sqlite3.h>

@implementation iOSDatabase

- (void)setDatabase:(sqlite3 *)db{
    _db = db;
}

// 打开数据库
+ (id)open:(NSString *)database{
    iOSDatabase *db = nil;
    NSString *filename = [NSString stringWithFormat:@"%@/%@", IOS_DATA_DATABASE, database];
    NSString *filepath = [iOSFile path:filename];
    iOSLog(@"SQLite3数据库: [%@]", filepath);
    sqlite3 *_db = NULL;
    if(sqlite3_open([filepath UTF8String], &_db) == SQLITE_OK) {
        // 数据库打开成功
        db = [[[iOSDatabase alloc] init] autorelease];
        [db setDatabase:_db];
    } else {
        iOSLog(@"Error: '%s(%d)'.", sqlite3_errmsg(_db), sqlite3_extended_errcode(_db));
    }
    return db;
}

// 释放对象
- (void)dealloc{
    if (_db != NULL) {
        sqlite3_close(_db);
        _db = NULL;
    }
    [super dealloc];
}

// 查询语句
- (BOOL)prepare:(NSString *)sql{
    BOOL bRet = NO;
    if (_stmt != NULL) {
        sqlite3_finalize(_stmt);
        _stmt = NULL;
    }
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        bRet = YES;
        _stmt = stmt;
    } else {
        bRet = NO;
        iOSLog(@"Error: '%s(%d)'.", sqlite3_errmsg(_db), sqlite3_extended_errcode(_db));
    }
    return bRet;
}

- (BOOL)bind:(int)n int:(int)m{
    BOOL bRet = NO;
    if (_stmt != NULL) {
        if(sqlite3_bind_int(_stmt, n, m) == SQLITE_OK){
            bRet = YES; 
        } else {
            bRet = NO;
            iOSLog(@"Error: '%s(%d)'.", sqlite3_errmsg(_db), sqlite3_extended_errcode(_db));
        }
    }
    return bRet;
}

- (BOOL)bind:(int)n int64:(long long)m64{
    BOOL bRet = NO;
    if (_stmt != NULL) {
        if(sqlite3_bind_int64(_stmt, n, m64) == SQLITE_OK){
            bRet = YES;
        } else {
            iOSLog(@"Error: '%s(%d)'.", sqlite3_errmsg(_db), sqlite3_extended_errcode(_db));
        }
    }
    return bRet;
}

- (BOOL)bind:(int)n double:(double)d{
    BOOL bRet = NO;
    if (_stmt != NULL) {
        if(sqlite3_bind_double(_stmt, n, d) == SQLITE_OK){
            bRet = YES;
        } else {
            iOSLog(@"Error: '%s(%d)'.", sqlite3_errmsg(_db), sqlite3_extended_errcode(_db));
        }
    }
    return bRet;
}

- (BOOL)bind:(int)n blob:(void *)value{
    BOOL bRet = NO;
    if (_stmt != NULL) {
        if (sqlite3_bind_blob(_stmt, n, value, -1, SQLITE_TRANSIENT) == SQLITE_OK) {
            bRet = YES;
        } else {
            iOSLog(@"Error: '%s(%d)'.", sqlite3_errmsg(_db), sqlite3_extended_errcode(_db));
        }
    }
    return bRet;
}

- (BOOL)bind:(int)n text:(NSString *)text{
    BOOL bRet = NO;
    if (_stmt != NULL) {
        if(sqlite3_bind_text(_stmt, n, [text UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK){
            bRet = YES;
        } else {
            iOSLog(@"Error: '%s(%d)'.", sqlite3_errmsg(_db), sqlite3_extended_errcode(_db));
        }
    }
    return bRet;
}

- (BOOL)execute{
    BOOL bRet = NO;
    if (_stmt != NULL) {
        if (sqlite3_step(_stmt) == SQLITE_ROW) {
            bRet = YES;
        } else {
            bRet = NO;
            iOSLog(@"Error: '%s(%d)'.", sqlite3_errmsg(_db), sqlite3_extended_errcode(_db));
        }
        sqlite3_finalize(_stmt);
        _stmt = NULL;
    }
    
    return bRet;
}

- (BOOL)execute2:(NSString *)sql{
    BOOL bRet = NO;
    if (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, nil) == SQLITE_OK) {
        bRet = YES;
    } else {
        bRet = NO;
        iOSLog(@"Error: '%s(%d)'.", sqlite3_errmsg(_db), sqlite3_extended_errcode(_db));
    }
    return bRet;
}

// 查询语句返回数组
- (NSMutableArray *)execute:(Class)clazz{
    NSMutableArray *aRet = nil;
    if (_stmt != NULL) {
        while (sqlite3_step(_stmt) == SQLITE_ROW) {
            if (aRet == nil) {
                aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            }
            id obj = nil;
            int count = sqlite3_column_count(_stmt);
            for (int i = 0; i < count; i++) {
                NSString *fieldName = [NSString stringWithCString:sqlite3_column_name(_stmt, i) encoding:NSUTF8StringEncoding];
                int fieldType = sqlite3_column_type(_stmt, i);
                if (obj == nil) {
                    obj = [[clazz alloc] init];
                }
                id value = nil;
                switch (fieldType) {
                    case SQLITE_INTEGER:
                        value = [NSNumber numberWithInt:sqlite3_column_int(_stmt, i)];
                        break;
                    case SQLITE_FLOAT:
                        value = [NSNumber numberWithDouble:sqlite3_column_double(_stmt, i)];
                        break;
                    default: // 默认为字符串
                        value = [NSString stringWithCString:(const char *)sqlite3_column_text(_stmt, i) encoding:NSUTF8StringEncoding];
                        break;
                }
                [iOSApi setObject:obj key:fieldName value:value];
            }
            [aRet addObject:obj];
            [obj release];
        }
        sqlite3_finalize(_stmt);
        _stmt = NULL;
    }
    return aRet;
}

/*
 smallint 16 位元的整数。
 interger 32 位元的整数。
 decimal(p,s) p 精确值和 s 大小的十进位整数，精确值p是指全部有几个数(digits)大小值，s是指小数点後有几位数。如果没有特别指定，则系统会设为 p=5; s=0 。
 float  32位元的实数。
 double  64位元的实数。
 char(n)  n 长度的字串，n不能超过 254。
 varchar(n) 长度不固定且其最大长度为 n 的字串，n不能超过 4000。
 graphic(n) 和 char(n) 一样，不过其单位是两个字元 double-bytes， n不能超过127。这个形态是为了支援两个字元长度的字体，例如中文字。
 vargraphic(n) 可变长度且其最大长度为 n 的双字元字串，n不能超过 2000
 date  包含了 年份、月份、日期。
 time  包含了 小时、分钟、秒。
 timestamp 包含了 年、月、日、时、分、秒、千分之一秒。
 
 datetime 包含日期时间格式，必须写成'2010-08-05'不能写为'2010-8-5'，否则在读取时会产生错误
 */
- (BOOL)addField:(NSString *)tableName
       fieldName:(NSString *)fieldName
       fieldType:(NSString *)fieldType{
    BOOL bRet = NO;
    NSString *sql = [NSString stringWithFormat:@"alter table `%@` add column `%@` %@ ''", tableName, fieldName, fieldType];
    if(sqlite3_exec(_db, [sql UTF8String], NULL, NULL, nil) == SQLITE_OK) {
        bRet = YES;
    } else {
        iOSLog(@"SQL[%@],Error: '%s'.", sql, sqlite3_errmsg(_db));
    }
    return bRet;
}

@end
