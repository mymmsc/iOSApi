//
//  HttpDownloader.h
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>

@protocol HttpDownloaderDelegate;

//--------------------< HTTP - 接口 - 下载 >--------------------
@interface HttpDownloader: NSObject{
    NSString        *_url;
    NSURLConnection *_connection;
    NSString        *_type;
    NSMutableData   *_data;
    long long        _fileLength;
    NSString        *_fileName;
    NSString        *_tempFile;
    NSDate          *_fileDate;
    BOOL             _fileExists;
    
    id               _delegate;
    id               _target;
    
}

@property (nonatomic, assign) id/*<HttpDownloaderDelegate>*/ delegate;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, assign) long long fileLength;
@property (nonatomic, copy)   NSString *fileName;
@property (nonatomic, copy)   NSString *tempFile;
@property (nonatomic, assign) id        target; // 允许携带第三方对象

- (void)bufferFromURL:(NSURL *)url;
- (void)cancel;

@end

//--------------------< HTTP - 接口 - 代理 >--------------------

@protocol HttpDownloaderDelegate

@optional
- (BOOL)httpDownloader:(HttpDownloader *)downloader didError:(BOOL)isError;
- (BOOL)httpDownloader:(HttpDownloader *)downloader didFinished:(NSMutableData *)buffer;
- (BOOL)httpDownloader:(HttpDownloader *)downloader didFinished:(NSMutableData *)buffer target:(id)target;

@end
