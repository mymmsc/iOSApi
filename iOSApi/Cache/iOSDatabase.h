//
//  iOSApi+Database.h
//  iOSApi
//
//  Created by wangfeng on 12-5-13.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>

// iOS本地数据库引擎
@interface iOSDatabase : NSObject{
    void *_db;   // sqlite3
    void *_stmt; // sqlite3_stmt
}

// 打开数据库
+ (id)open:(NSString *)database;

// 预编译SQL语句
- (BOOL)prepare:(NSString *)sql;
- (BOOL)bind:(int)n int:(int)m;
- (BOOL)bind:(int)n int64:(long long)m64;
- (BOOL)bind:(int)n double:(double)d;
- (BOOL)bind:(int)n blob:(void *)value;
- (BOOL)bind:(int)n text:(NSString *)text;
// 仅对不要求记录集的SQL语句有效
- (BOOL)execute;
// 只返回执行是否成功
- (BOOL)execute2:(NSString *)sql;
// 查询语句返回数组, 对记录集进行封装, 返回一个包含clazz类对象的数组
- (NSMutableArray *)execute:(Class)clazz;

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
       fieldType:(NSString *)fieldType;
@end
