//
//  UIViewController+KeyBoard.h
//  iOSApi
//
//  Created by WangFeng on 11-11-12.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi+UIKit.h>

/**
 * 扩展UIViewController键盘操作类
 * @brief 解决当前视图所有文本输入框被键盘挡住的问题
 */
@interface UIViewController (KeyBoard)

- (void)registerForKeyboardNotifications;
// Call this method somewhere in your view controller setup code.
- (void) unregisterForKeyboardNotifications;

@end
