//
//  UIViewController+KeyBoard.m
//  iOSApi
//
//  Created by WangFeng on 11-11-12.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/UIViewController+KeyBoard.h>

@implementation UIViewController (KeyBoard)

// 当前即将进行编辑的文本输入框
static UITextField *s_activeTextField = nil;
static int s_center_x = -1;
static int s_center_y = -1;

/**
 * 滚动视图
 * @param height 高度的偏移
 */
- (void)viewScroll:(int)height {
    [UIView beginAnimations: @"keyboardScrollUp" context: nil];
    int x = self.view.center.x;
    int y = self.view.center.y;
    if (s_center_x == -1) {
        s_center_x = x;
        s_center_y = y;
    }
    CGPoint centerPoint = CGPointMake(x, y - height);
    self.view.center = centerPoint;
    [UIView commitAnimations];
}

// 开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    s_activeTextField = textField;
    iOSLog(@"[%@], begin editing...", textField);
}

// 结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    s_activeTextField = nil;
    [textField resignFirstResponder];
    iOSLog(@"[%@], end editing...", textField);
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWasShown:) name: UIKeyboardDidShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object: nil];
    /*
    // 键盘高度变化通知, iOS5新增, 这个事件会导致中心区域定位不准确
#ifdef __IPHONE_5_0
    float fversion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (fversion >= 5.0f) {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillShow:) name: UIKeyboardWillChangeFrameNotification object: nil];
    }
#endif
     */
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *field = (UITextField *)view;
            [field addTarget: self action: @selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            [field addTarget: self action: @selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
            field.returnKeyType = UIReturnKeyNext;
        }
    }
}

// Call this method somewhere in your view controller setup code.
- (void) unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// XXX: Called when the UIKeyboardDidShowNotification is sent
-(void)keyboardWillShow: (NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.bounds;
    aRect.size.height -= kbSize.height;
	// 输入项区域被认为定高
	CGPoint activeFieldRect = s_activeTextField.frame.origin;
	activeFieldRect.y += s_activeTextField.frame.size.height;
    if (!CGRectContainsPoint(aRect, activeFieldRect) ) {
        [self viewScroll: activeFieldRect.y - kbSize.height];
    }
}

// Called when the UIKeyboardDidShowNotification is sent
-(void)keyboardWasShown: (NSNotification *)aNotification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [aNotification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    // 计算键盘高度
    CGFloat keyboardTop = keyboardRect.origin.y;
       
    // 输入项区域被认为定高
	CGRect activeFieldRect = s_activeTextField.frame;
    CGFloat activeFieldHeight = activeFieldRect.origin.y + activeFieldRect.size.height; 
    
    int span = activeFieldHeight - keyboardTop + 50;
    if (span > 0 ) {
        iOSLog(@"keyboard move %d.", span);
        [self viewScroll: span];
    } else {
        [self viewScroll: 0];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView beginAnimations: @"keyboardScrollDown" context: nil];
    
    CGPoint centerPoint = CGPointMake(s_center_x, s_center_y);
    self.view.center = centerPoint;
    
    [UIView commitAnimations];
}

@end
