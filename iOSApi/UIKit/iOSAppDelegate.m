//
//  iOSAppDelegate.h
//  iOSApi
//
//  Created by WangFeng on 11-12-11.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSAppDelegate.h"
#import <iOSApi/iOSTabBarController.h>

@implementation iOSAppDelegate
@synthesize tabBarController, window, delegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	self.tabBarController = [[[iOSTabBarController alloc] init] autorelease];
    NSArray *list = [self.delegate pushViewControllers:self];
	self.tabBarController.viewControllers = list;
	[self.window addSubview:self.tabBarController.view];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
