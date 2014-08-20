//
//  iOSApi.h
//  iOSApi
//
//  Created by WangFeng on 2011-12-18.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
//====================================< 通用 - 宏 >====================================

// iOSApi版本号
#define IOSAPI_VERSION @"3.0.2"

//--------------------< 通用 - 宏 - 调试开关 >--------------------
#define DEBUG_MODE 1
#ifdef DEBUG_MODE 
#define iOSLog( s, ... ) NSLog( @"<%s : (%d)> %@",__PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] ) 
#else 
#define iOSLog( s, ... )  
#endif

// 调试标识
#define IOSAPI_DEBUG (1)

#define IOSAPI_HAVE_UDID (0)

//--------------------< 通用 - 常量 - 尺寸 >--------------------
// xKB
#define IOSAPI_KB(x) ((x) * 1024)
// xMB
#define IOSAPI_MB(x) (IOSAPI_KB(x) * 1024)

//--------------------< 通用 - 宏 - 中国内地手机号码长度 >--------------------
// 默认手机号码长度为11位
#define ISP_PHONE_MAXLENGTH (11)

#define IOSAPI_RELEASE(p) do{ if((p) != nil) { [(p) release]; (p) = nil; } } while(0)

//--------------------< 通用 - 数据类型 >--------------------
typedef long long api_int64_t;

//====================================< 通用 - 接口 >====================================

@interface iOSApi : NSObject

//--------------------< 通用 - 接口 - 应用程序相关 >--------------------

/**
 * 关闭应用程序
 * @return void
 */
+ (void)AppClose;

// 获得版本号
+ (NSString *)version;

// ipa版本号和version参数比较, 是否需要更新
+ (BOOL)isNeedUpload:(NSString *)version;

//--------------------< 通用 - 接口 - 标准用户缓存信息 >--------------------
+ (NSUserDefaults *)cache;

/** 从用户数据区取出字符串 */
+ (NSString *)objectForCache:(NSString *)key;

/** 向用户数据去存储字符串 */
+ (void)cacheSetObject:(NSString *)key
				 value:(NSString *)value;

//--------------------< 通用 - 接口 - 类反射 >--------------------

+ (id)objectFrom:(NSString *)clazz;

/**
 * 给对象赋值, 字段名必须一致
 */
+ (BOOL)setObject:(NSObject *)obj
         property:(objc_property_t)property
            value:(id)value;

/**
 * 对象字段赋值, 字段名忽略大小写
 * @param obj 目标对象
 * @param key 字段名
 * @param value 值
 */
+ (BOOL)setObject:(NSObject *)obj key:(NSString *)key value:(id)value;

//--------------------< 通用 - 接口 - 编码 >--------------------
+ (NSString *)o3String:(int)length;

/**
 * 创建GUID
 */
+ (NSString *)createUUID;

//--------------------< 通用 - 接口 - 随机数相关 >--------------------

/**
 * md5
 * @remark 对字符串进行加密
 */
+ (NSString *)md5:(NSString *)str;

//--------------------< 通用 - 接口 - 文件系统 >--------------------

/**
 * 创建多级目录
 */
+ (BOOL)mkdirs:(NSString *)path;

/**
 * 获取当前文档路径
 */
+ (NSString *)mainPath;

//--------------------< 通用 - 接口 - 正则表达式 >--------------------

+ (BOOL)regexpMatch:(NSString *)string withPattern:(NSString *)pattern;

//--------------------< 通用 - 接口 - 验证 >--------------------
// 判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)string;

@end

