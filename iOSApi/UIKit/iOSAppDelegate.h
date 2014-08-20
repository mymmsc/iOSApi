//
//  iOSAppDelegate.h
//  iOSApi
//
//  Created by WangFeng on 11-12-11.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi+UIKit.h>

@class iOSTabBarController;
@protocol iOSApplicationDelegate;

@interface iOSAppDelegate : NSObject <UIApplicationDelegate> {
	iOSTabBarController *tabBarController;
	UIWindow *window;
}

@property (nonatomic, retain) iOSTabBarController *tabBarController;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, assign) id<iOSApplicationDelegate> delegate;
@end

@protocol iOSApplicationDelegate

- (NSArray *)pushViewControllers:(iOSAppDelegate *)appDelegate;

@end