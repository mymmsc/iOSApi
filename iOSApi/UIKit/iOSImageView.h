//
//  ImageView.h
//  iOSApi
//
//  Created by wangfeng on 12-3-11.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi+UIKit.h>
#import <iOSApi/HttpDownloader.h>

@interface iOSImageView : UIImageView<HttpDownloaderDelegate> {
    HttpDownloader *download;
}

@property (nonatomic, assign) BOOL isReady;

- (void)imageWithURL:(NSString *)url;

@end
