//
//  iOSApi+UIKit.m
//  iOSApi
//
//  Created by wangfeng on 12-6-23.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSApi+UIKit.h"

@implementation iOSApi (UIKit)

/**
 * 调用默认浏览器, 打开一个网页
 */
+ (BOOL)openUrl:(NSString *)url {
	NSURL *uri = [NSURL URLWithString: url];
	return [[UIApplication sharedApplication] openURL: uri];
}

+ (id)objectFrom:(NSString *)clazz
             nib:(NSString *)nib {
    Class cls = NSClassFromString(clazz);
    
    return [[[cls alloc] initWithNibName:nib bundle:nil] autorelease];
}

//--------------------< 通用 - 接口 - 图像 >--------------------
+ (UIImage *)imageNamed:(NSString *)filename  {
	NSString *ext = [filename pathExtension];
	NSRange range = [filename rangeOfString: ext];
	NSString *name = [filename substringToIndex: (range.location - 1)];
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
	return [UIImage imageWithContentsOfFile: path];
}

//--------------------< 通用 - 接口 - 文本 >--------------------

#define CELL_CONTENT_MARGIN 3.0f // 文本两边空白宽度

// 计算文本高度
+ (CGFloat)heightForString_OLD:(NSString *)text width:(CGFloat)width font:(UIFont *)font{
    CGSize constraint = CGSizeMake(width - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 44.0f);
    return height + (CELL_CONTENT_MARGIN * 2);
}

+ (CGFloat)heightForString:(NSString *)text width:(CGFloat)width font:(UIFont *)font{
    CGSize constraint = CGSizeMake(width - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

+ (CGFloat)heightForString:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize{
    return [self heightForString:text width:width font:[UIFont systemFontOfSize:fontSize]];
}

//--------------------< 通用 - 接口 - 背景图片 >--------------------
// 平铺背景图片
+ (UIColor *)colorWithImage:(UIImage *)image{
    return [UIColor colorWithPatternImage:image];
}

@end
