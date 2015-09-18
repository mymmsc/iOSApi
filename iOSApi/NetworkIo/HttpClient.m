//
//  iOSHttpClient.m
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/HttpClient.h>
#import <iOSApi/NSString+Utils.h>

@implementation HttpClient
@synthesize statusCode,statusDescription;

//static NSMutableDictionary *g_cookies = nil;

- (void)dealloc {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    IOSAPI_RELEASE(requestBody);
    [conn cancel];
    IOSAPI_RELEASE(conn);
    IOSAPI_RELEASE(buffer);
    
    [super dealloc];
}

- (id)initWithURL:(NSString *)url timeout:(int)interval {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    IOSAPI_RELEASE(conn);
    IOSAPI_RELEASE(buffer);
    IOSAPI_RELEASE(requestBody);
    
    statusCode = 404;
    statusDescription = @"Not Found";
    
    timeout = interval;
    requestBody = [[NSMutableData alloc] initWithCapacity:0];
    boundary = [iOSApi o3String: 14];
    NSURL *tmpUrl = [NSURL URLWithString:url];
    //request = [NSMutableURLRequest requestWithURL:tmpUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    request = [NSMutableURLRequest requestWithURL:tmpUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:timeout];
    //[request setTimeoutInterval:interval];
    NSString *myContent = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request setValue:myContent forHTTPHeaderField:@"Content-type"];
    return self;
}

// 增加表单字段键值, 编码UTF-8
- (void)formAddField:(NSString *)field value:(id)value {
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
    [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", field, value] dataUsingEncoding:NSUTF8StringEncoding]];
}

// 增加二进制文件
- (void)formAddFile:(NSString *)field filename:(NSString *)filename type:(NSString *)type data:(NSData *)data {
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    if (type != nil) {
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n", field, filename, type] dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type:application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n", field, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [requestBody appendData:data];
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

// 增加图片文件
- (void)formAddImage:(NSString *)field filename:(NSString *)filename data:(NSData *)data {
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: image/png\r\n\r\n", field, filename] dataUsingEncoding:NSUTF8StringEncoding]]; 
    [requestBody appendData:data];
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

// 增加二进制文件
- (void)formAddFile:(NSString *)field filename:(NSString *)filename data:(NSData *)data {
    NSString *type = @"application/octet-stream\r\nContent-Transfer-Encoding: binary";
    [self formAddFile:field filename:filename type:type data:data];
}

- (void)formAddFields:(NSDictionary*)dictionary {
	NSArray *formKeys = [dictionary allKeys];
	for (int i = 0; i < [formKeys count]; i++) {
        NSString *key = [formKeys objectAtIndex:i];
		[self formAddField: key value:[dictionary valueForKey:key]];
	}
}

// HttpClient 发起请求, 如果body为nil, 则以GET方式请求
- (NSData *)post:(NSDictionary *)headers body:(NSData *)data{
    if (headers != nil && headers.count > 0) {
        NSArray *keys = [headers allKeys];
        for (NSString * key in keys) {
            key = [key trim];
            NSString *value = [headers objectForKey: key];
            if (key.length > 0 && value != nil) {
                //[request addValue: value forHTTPHeaderField:key];
                [request setValue:[value trim] forHTTPHeaderField:key];
            }            
        }
    } else {
        //
    }
    
#if IOSAPI_HAVE_UDID
    NSString *did = [[UIDevice currentDevice] uniqueIdentifier];
    iOSLog(@"udid = [%@]", did);
    [request setValue:[did trim] forHTTPHeaderField:@"imei"];
#endif
    
    if (data != nil && data.length > 0) {
        iOSLog(@"POST 方法");
        NSString *body_length = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
        [request setValue:body_length forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:data];
        [request setHTTPMethod:@"POST"];
    } else {
        iOSLog(@"GET 方法");
        [request setValue:nil forHTTPHeaderField:@"Content-type"];
        [request setHTTPMethod:@"GET"];
    }
    
    NSDictionary *head = [request allHTTPHeaderFields];
    //[request setTimeoutInterval:timeout];
    NSArray *tmpField = [head allKeys];
    NSMutableString *tmpHead = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    for (NSString *tmpKey in tmpField) {
        [tmpHead appendFormat:@"%@: %@\r\n", tmpKey, [head objectForKey:tmpKey]];
    }
    NSString *s = [NSString stringWithString:tmpHead];
    iOSLog(@"HTTP-Header: \n%@", s);
    NSString *json_string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    iOSLog(@"request= %@, timeout=%g", json_string, timeout);
    //自定义时间超时
    NSTimeInterval timeInterval = timeout;
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    NSData *resp_data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // 如果定时器有效, 停止它.
    if (timer.isValid) {
        [timer invalidate];
    }
    statusCode = (int)response.statusCode;
    statusDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
    iOSLog(@"%@ 请求: status=%ld", [request URL], response.statusCode);
    if (response == nil || response.statusCode >= 400 ) {
        iOSLog(@"%@ 异常: [%d]%@", [request URL], (int)[error code], [error localizedDescription]);
    } else {
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            NSLog(@"%@", cookie);
        }
    }
    
    return resp_data;
}

- (void)handleTimer:(NSTimer *)theTimer{
    iOSLog(@"超时%g秒主动关闭连接.", timeout);
    [conn cancel];
    statusCode = kHttpTimeout;
    statusDescription = sHttpTimeOut;
}

- (NSData *)post:(NSDictionary *)headers {
    if (requestBody.length > 0) {
        // 添加最后结束标识
        [requestBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return [self post:headers body:requestBody];
}

// 提交
- (NSData *)post{
    return [self post:nil];
}

- (id)header:(NSString *)field {
    id object = nil;
    NSDictionary *list = [response allHeaderFields];
    if (list != nil && [list count] > 0) {
        object = [list objectForKey:field];
    }
    return object;
}

- (NSString *)description {
    return [error localizedDescription];
}

@end

#include <assert.h>
//#include <CoreServices/CoreServices.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <unistd.h>

static uint64_t GetPIDTimeInNanoseconds(void)
{
    uint64_t        start;
    uint64_t        end;
    uint64_t        elapsed;
    uint64_t        elapsedNano;
    static mach_timebase_info_data_t    sTimebaseInfo;
    
    // Start the clock.
    
    start = mach_absolute_time();
    
    // Call getpid. This will produce inaccurate results because 
    // we're only making a single system call. For more accurate 
    // results you should call getpid multiple times and average 
    // the results.
    
    (void) getpid();
    
    // Stop the clock.
    
    end = mach_absolute_time();
    
    // Calculate the duration.
    
    elapsed = end - start;
    
    // Convert to nanoseconds.
    
    // If this is the first time we've run, get the timebase.
    // We can use denom == 0 to indicate that sTimebaseInfo is 
    // uninitialised because it makes no sense to have a zero 
    // denominator is a fraction.
    
    if ( sTimebaseInfo.denom == 0 ) {
        (void) mach_timebase_info(&sTimebaseInfo);
    }
    
    // Do the maths. We hope that the multiplication doesn't 
    // overflow; the price you pay for working in fixed point.
    
    elapsedNano = elapsed * sTimebaseInfo.numer / sTimebaseInfo.denom;
    
    return elapsedNano;
}
