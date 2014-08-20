//
//  iOSHttpClient.h
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi+UIKit.h>

#define kHttpTimeout 901
#define sHttpTimeOut @"操作超时"

@interface HttpClient : NSObject{
    NSURLConnection     *conn;
    NSMutableData       *buffer;
    NSMutableURLRequest *request;
    NSMutableData       *requestBody;
    NSString            *boundary;
    NSHTTPURLResponse   *response;
    NSError             *error;
    
    NSTimer             *timer;
    NSTimeInterval       timeout;
}
@property (nonatomic, assign) int statusCode;         // 状态码
@property (nonatomic, copy) NSString *statusDescription; // 状态描述

- (id)initWithURL:(NSString *)url timeout:(int)interval;
- (void)handleTimer:(NSTimer *)theTimer;
// 增加表单字段键值, 编码UTF-8
- (void)formAddField:(NSString *)field value:(id)value;

// 增加二进制文件
- (void)formAddFile:(NSString *)field filename:(NSString *)filename type:(NSString *)type data:(NSData *)data;

// 增加图片文件
- (void)formAddImage:(NSString *)field filename:(NSString *)filename data:(NSData *)data;

// 增加文件
- (void)formAddFile:(NSString *)field filename:(NSString *)filename data:(NSData *)data;

- (void)formAddFields:(NSDictionary*)dictionary;

/*!
    @method post:body:
    @abstract 提交一个HTTP 客户端的请求.
    @discussion 如果data为nil, 则自动变为GET请求.
    @param headers HTTP-Header字段数组.
    @param data HTTP-Body数据流.
    @result 返回HTTP服务器响应Body
 */
- (NSData *)post:(NSDictionary *)headers body:(NSData *)data;

- (NSData *)post:(NSDictionary *)headers;

- (NSData *)post;

/**
 * 获得HTTP-Response-Header域字段值
 */
- (id)header:(NSString *)field;

- (NSString *)description;
@end
