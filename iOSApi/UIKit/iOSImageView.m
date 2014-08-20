//
//  ImageView.m
//  iOSApi
//
//  Created by wangfeng on 12-3-11.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSImageView.h"
#import "UIImage+Utils.h"
#import <iOSApi/UIImageView+Utils.h>

@implementation iOSImageView
@synthesize isReady;

- (void)dealloc {
    IOSAPI_RELEASE(download);
    [super dealloc];
}

- (void)imageWithURL:(NSString *)url{
    isReady = NO;
    download = [HttpDownloader new];
    download.delegate = self;
    [download bufferFromURL:[NSURL URLWithString:url]];
}

- (BOOL)httpDownloader:(HttpDownloader *)downloader didError:(BOOL)isError{
    BOOL bRet = NO;
    // 如果下载失败, 则不进行显示
    return bRet;
}

- (BOOL)httpDownloader:(HttpDownloader *)downloader didFinished:(NSMutableData *)buffer{
    BOOL bRet = NO;
    UIImage *image = [UIImage imageWithData:buffer];
    
	[UIView beginAnimations:nil context:nil];
	//display mode, slow at beginning and end
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	//动画时间
	[UIView setAnimationDuration:1.0f];
	//使用当前正在运行的状态开始下一段动画
	[UIView setAnimationBeginsFromCurrentState:YES];
	//给视图添加过渡效果
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
	[UIView commitAnimations];
	
	[self loadImage:image];
    isReady = YES;
    return bRet;
}

@end
