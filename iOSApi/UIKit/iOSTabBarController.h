//
//  iOSTabBarController.h
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>
#import <iOSApi/iOSTabBar.h>

@class iOSTabBarView;

@interface iOSTabBarController : UIViewController <iOSTabBarDelegate> {
    NSArray *_viewControllers;
    iOSTabBar *tabBar;
    UIViewController *selectedViewController;
    iOSTabBarView *tabBarView;
    NSUInteger selectedIndex;
    BOOL visible;
}

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) iOSTabBar *tabBar;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) iOSTabBarView *tabBarView;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, readonly) BOOL visible;

@end
