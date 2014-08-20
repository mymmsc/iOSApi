//
//  HttpDownloader.m
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "HttpDownloader.h"
#import <iOSApi/iOSApi+UIKit.h>
#import "NSDate+Utils.h"
#import "NSString+Utils.h"
#import "iOSCache.h"
#import "iOSFile.h"

//--------------------< HTTP - 接口 - 下载 >--------------------

@implementation HttpDownloader

@synthesize delegate = _delegate;
@synthesize type = _type, fileLength = _fileLength, fileName = _fileName, tempFile = _tempFile;
@synthesize target = _target;

- (void)bufferFromURL:(NSURL *)url {
    if (_connection != nil) {
        [_connection release];
    }
    if (_data != nil) {
        [_data release];
    }
    _url = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    _tempFile = [[iOSCache cacheAsUrl:_url] copy];
    NSDate *tmpDate = nil;
    NSString *filepath = [iOSFile path:_tempFile];
    //iOSLog(@"[%@]的文件cache[%@].", _url, filepath);
    _fileExists = NO;
    _fileExists = [[iOSFile manager] fileExistsAtPath:filepath];
    if (_fileExists) {
        //iOSLog(@"发现[%@]的文件cache[%@].", _url, _tempFile);
        tmpDate = [iOSFile fileDate:_tempFile];
    }
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setTimeoutInterval:30.0f];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [request setHTTPMethod:@"GET"];
    if (tmpDate) {
        NSString *tmp = [tmpDate rfc1123String];
        [request setValue:tmp forHTTPHeaderField:@"If-Modified-Since"];
    }
#if IOSAPI_HAVE_UDID
    NSString *did = [[UIDevice currentDevice] uniqueIdentifier];
    [request setValue:[did trim] forHTTPHeaderField:@"imei"];
#endif
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancel{
    _fileDate = nil;
    if (_connection != nil) {
        [_connection cancel];
        [_connection release];
        _connection = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse*)response {
    //response saved so that status Codes can be checked later
    NSDictionary* headers = [response allHeaderFields];
#if 0
    iOSLog(@"HTTP->Header:");
    for (NSString *key in [headers allKeys]) {
        iOSLog(@"[%@]->[%@]", key, [headers objectForKey:key]);
    }
#endif
    // 取得内容长度
    NSString *temp = [headers objectForKey:@"Content-Length"];
    if (temp != nil && temp.length > 0) {
        _fileLength = [temp longLongValue];
    }
    // 内容类型
    temp = [headers objectForKey:@"Content-Type"];
    if (temp != nil && temp.length > 0) {
        _type = [[NSString alloc] initWithString:temp];
    }    
    
    temp = [headers objectForKey:@"Content-Disposition"];
    if (temp.length > 0) {
        NSRange range = [temp rangeOfString:@"="];
        if (range.location > 0 && range.length > 0) {
            NSString *name = [temp substringFromIndex:range.location+1];
            _fileName = [[NSString alloc] initWithString:[name stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        }
    }
    
    // 取得文件日期
    temp = [headers objectForKey:@"Last-modified"];
    if (temp != nil) {
        _fileDate = [[NSDate dateFromRFC1123:temp] retain];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
        iOSLog(@"文件最后修改时间:[%@]->[%@]",temp, [formatter stringFromDate:_fileDate]);
        [formatter release];
    }
    //iOSLog(@"HTTP-Status: [%d]",response.statusCode);
    BOOL bContinue = NO;
    switch (response.statusCode) {
        case 200:
        case 206:
            bContinue = YES;
            break;
        case 304: // 没有变化
        default:
            bContinue = NO;
            break;
    }
    if (!bContinue && _fileExists) {
        NSString *filepath = [iOSFile path:_tempFile];
        _data = [[NSMutableData alloc] initWithCapacity:0];
        NSData *tmpData = [NSData dataWithContentsOfFile:filepath];
        [_data appendData:tmpData];
        _fileLength = [_data length];
        [self connectionDidFinishLoading:nil];
    } else {
        _data = nil;
        _fileExists = NO;
    }
}

// 网络异常
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    _data = nil;
    // Release the connection now that it's finished
    _connection = nil;
    // Call 
    if ([_delegate respondsToSelector:@selector(httpDownloader:didError:)]) {
        [_delegate httpDownloader:self didError:YES];
    }
}

// 接收数据
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (_data == nil) {
        _data = [[NSMutableData alloc] initWithCapacity:0];
    }
    [_data appendData:incrementalData];
}

// 接收数据完成
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    if (_connection != nil) {
        [_connection cancel];
        [_connection release];
        _connection = nil;
    }
    _fileLength = _data.length;
    if (!_fileExists) {
        NSFileHandle *fileHandle = [iOSFile create:_tempFile];
        [fileHandle writeData:_data];
        [fileHandle closeFile];
        [iOSFile setDate:_tempFile date:_fileDate];
    }
    if ([_delegate respondsToSelector:@selector(httpDownloader:didFinished:target:)]) {
        [_delegate httpDownloader:self didFinished:_data target:_target];
    } else if ([_delegate respondsToSelector:@selector(httpDownloader:didFinished:)]) {
        [_delegate httpDownloader:self didFinished:_data];
    }
}

- (void)dealloc {
    [self cancel];
    IOSAPI_RELEASE(_fileName);
    IOSAPI_RELEASE(_tempFile);
    IOSAPI_RELEASE(_data);
    IOSAPI_RELEASE(_type);
    //NSString        *_url;
    //NSURLConnection *_connection;
    //NSString        *_type;
    //NSMutableData   *_data;
    //NSString        *_fileName;
    //NSString        *_tempFile;
    //NSDate          *_fileDate;
    IOSAPI_RELEASE(_fileDate);
    [super dealloc];
}

@end
