//
//  iOSApi+UIKit.h
//  iOSApi
//
//  Created by wangfeng on 12-6-23.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSApi.h"
#import <UIKit/UIKit.h>

@interface iOSApi (UIKit)

/**
 * 调用默认浏览器, 打开一个网页
 */
+ (BOOL)openUrl:(NSString *)url;


+ (id)objectFrom:(NSString *)clazz nib:(NSString *)nib;

//--------------------< 通用 - 接口 - 图像 >--------------------
+ (UIImage *)imageNamed:(NSString *)filename;

//--------------------< 通用 - 接口 - 文本 >--------------------
// 计算文本高度
+ (CGFloat)heightForString:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)heightForString:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize;

//--------------------< 通用 - 接口 - 背景图片 >--------------------
// 平铺背景图片
+ (UIColor *)colorWithImage:(UIImage *)image;


@end
