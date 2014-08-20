//
//  UIImage+Utils.h
//  iOSApi
//
//  Created by wangfeng on 12-3-6.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi+UIKit.h>

// 图片相关处理扩展类
@interface UIImage (Utils)

// 修订缩放尺寸, 以目标尺寸的实际大小为基准等比例缩放
- (CGSize)fixSize:(CGSize)size;

// 图片缩放
- (UIImage *)toSize:(CGSize)size;

// 等比例缩放
- (UIImage *)toScale:(float)scaleScale;

// Convert the image's fill color to the passed in color
- (UIImage*)imageFilledWith:(UIColor*)color using:(UIImage*)startImage;

// nine-patch .9.png
+ (UIImage *)imageWithNinePatch:(NSString *)filename size:(CGSize)size;

@end
