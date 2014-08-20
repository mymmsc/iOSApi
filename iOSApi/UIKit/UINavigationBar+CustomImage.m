//
//  UINavigationBar+CustomImage.m
//  iOSApi
//
//  Created by WangFeng on 11-12-6.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/UINavigationBar+CustomImage.h>

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"NavigationBar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

