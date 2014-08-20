//
//  UINavigationController+icons.m
//  iOSApi
//
//  Created by wangfeng on 12-3-6.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/UINavigationController+icons.h>
#import <iOSApi/UIViewController_TabBar.h>

@implementation UINavigationController (icons)

- (NSString *)iconName {
	return [[self.viewControllers objectAtIndex:0] iconName];
}

@end
