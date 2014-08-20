//
//  iOSApi+Window.h
//  iOSApi
//
//  Created by WangFeng on 11-12-11.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi+UIKit.h>
//====================================< 通用 - 宏 >====================================

// 以弹出窗体模式显示图片
@interface iOSApi (Window)
//--------------------< 通用 - 接口 - 应用程序相关 >--------------------
// 弹出警告窗体
+ (void) Alert:(NSString *)title
       message:(NSString *)message;

// 弹出窗体模式 - 显示图片
+ (void)showImage:(NSString *)uri;

+ (void)showImage2:(NSString *)uri view:(UIViewController *)view;

//--------------------< 通用 - 接口 - 提示框相关 >--------------------
+ (void)showAlert:(NSString *)message;
+ (void)showCompleted:(NSString *)message;
+ (void)closeAlert;

// 显示短暂的消息
+ (void)toast:(NSString *)message;

@end
