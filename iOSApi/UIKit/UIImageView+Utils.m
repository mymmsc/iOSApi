//
//  UIImageView+Utils.m
//  iOSApi
//
//  Created by wangfeng on 12-3-24.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "UIImageView+Utils.h"
#import "UIImage+Utils.h"
#import "HttpDownloader.h"
#import "iOSUnknown.h"
#import <objc/runtime.h>

@implementation UIImageView (Utils)

- (void)loadImage:(UIImage *)image{
    if (image != nil && image.size.width > 0) {
        CGRect frame = self.frame;
        CGSize size = frame.size;
        CGFloat max_width = size.width;
        CGFloat max_height = size.height;
        
        CGSize imgSize = image.size;
        // 图片宽高比例
        CGFloat scale = 0;
        // 确定以高还是宽为主进行缩放
        if ((imgSize.width / imgSize.height) > (max_width / max_height)) {
            // 以宽
            if (max_width < imgSize.width) {
                // 图片宽
                scale = max_width / imgSize.width;
            } else {
                // 图片窄
                scale = 1;
            }
        } else {
            // 以高
            if (max_height < imgSize.height) {
                // 图片高
                scale = max_height / imgSize.height;
            } else {
                scale = 1;
            }
        }
        
        CGFloat w = imgSize.width * scale;
        CGFloat h = imgSize.height * scale;
        
        frame.origin.x += (size.width - w) / 2;
        frame.origin.y += (size.height - h) / 2;
        frame.size.width = w;
        frame.size.height = h;
        
        self.image = [image toSize:CGSizeMake(w, h)];
        self.frame = frame;
    }
}

- (void)imageWithURL:(NSString *)url{
    HttpDownloader *downloader = [[[HttpDownloader alloc] init] autorelease];
    //[iOSUnknown set:download value:download];
    NSURL *tmpUrl = [NSURL URLWithString:url];
    downloader.delegate = self;
    [downloader bufferFromURL:tmpUrl];
    //[download release];
}

- (BOOL)httpDownloader:(HttpDownloader *)client didError:(BOOL)isError {
    iOSLog(@"图片下载失败.");
    //[self stopTransfer:client];
    return NO;
}

- (BOOL)httpDownloader:(HttpDownloader *)client didFinished:(NSMutableData *)buffer {
    //[self stopTransfer];
    UIImage *image = [UIImage imageWithData:buffer];
    if (image != nil && image.size.width > 0) {
        [self loadImage:image];
        iOSLog(@"图片下载成功.");
    } else {
        iOSLog(@"图片下载失败.");
    }
    //[self stopTransfer:client];
    return NO; 
}

@end
