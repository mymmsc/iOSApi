//
//  UIImage+Utils.m
//  iOSApi
//
//  Created by wangfeng on 12-3-6.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/UIImage+Utils.h>
#import <iOSApi/TUNinePatchCache.h>

#define IPHONE_PHOTO_SCALE ((float)2592/(float)1936)

@implementation UIImage (Utils)

// 修订缩放尺寸
- (CGSize)fixSize:(CGSize)size{
    // 返回的修订尺寸
    CGSize sizeRet;
    CGSize sizeOrig = self.size;
    
    CGFloat scale = 1;
    CGFloat max_width = 0;
    CGFloat max_height = 0;
    
    // 判断缩放的基准
    if (sizeOrig.width / sizeOrig.height >= size.width / size.height) {
        // 以新尺寸的宽为基准
        scale = size.width / sizeOrig.width;
    } else {
        scale = size.height / sizeOrig.height;
    }
    
    max_width = sizeOrig.width * scale;
    max_height = sizeOrig.height * scale;
    sizeRet = CGSizeMake(max_width, max_height);
    
    return sizeRet;
}

// 图片缩放
- (UIImage *)toSize:(CGSize)size{
    // 对缩放的尺寸进行修正
    CGSize newSize = size;//[self fixSize:size];
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newSize);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

// 等比例缩放
- (UIImage *)toScale:(float)scaleScale{
    // 原尺寸
    CGSize sizeOrig = self.size;
    CGFloat width = sizeOrig.width * scaleScale;
    CGFloat height = sizeOrig.height * scaleScale;
    CGSize size = CGSizeMake(width, height);
    
    return [self toSize:size];
    
}

// Convert the image's fill color to the passed in color
- (UIImage *)imageFilledWith:(UIColor*)color using:(UIImage*)startImage
{
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color
    CGContextSetFillColorWithColor(context, color.CGColor);
    // Fill with color
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

+ (UIImage *)imageWithNinePatch:(NSString *)filename size:(CGSize)size{
    return [TUNinePatchCache imageOfSize:size forNinePatchNamed:filename];
}

@end
