//
//  iOSTabBar.h
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>
#import <iOSApi/iOSTab.h>

@protocol iOSTabBarDelegate;

@interface iOSTabBar : UIView {
    NSArray *tabs;
    iOSTab *selectedTab;
    id <iOSTabBarDelegate> delegate;
    UIImageView *arrow;
}

- (id)initWithFrame:(CGRect)aFrame;
- (void)setSelectedTab:(iOSTab *)aTab animated:(BOOL)animated;

@property (nonatomic, retain) NSArray *tabs;
@property (nonatomic, retain) iOSTab *selectedTab;
@property (nonatomic, assign) id <iOSTabBarDelegate> delegate;
@property (nonatomic, retain) UIImageView *arrow;
@end

@protocol iOSTabBarDelegate
- (void)tabBar:(iOSTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index;
@end