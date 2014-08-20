//
//  iOSImageView.h
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpDownloader.h"

@protocol ImageViewDelegate;

@interface iOSImageView2 : UIView<HttpDownloaderDelegate> {
    UIView                  *mainView;
    UIActivityIndicatorView *activity;
    UIImage                 *m_image;
    HttpDownloader          *httpClient;
    id                       delegate;
}

@property (nonatomic, assign) id<ImageViewDelegate> delegate;

- (id)initWithImage:(UIImage *)image superView:(UIView *)aView;

- (id)initWithUrl:(NSString *)url superView:(UIView *)aView;

@end

//--------------------< HTTP - 接口 - 代理 >--------------------

@protocol ImageViewDelegate

@optional
- (void)imageViewWillClose:(iOSImageView2 *)imageView;

@end
