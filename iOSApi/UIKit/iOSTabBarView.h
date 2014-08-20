//
//  iOSTabBarView.h
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//
#import <iOSApi/iOSApi+UIKit.h>

@class iOSTabBar;

@interface iOSTabBarView : UIView{
    UIView *contentView;
    iOSTabBar *tabBar;
}

@property (nonatomic, assign) UIView *contentView;
@property (nonatomic, assign) iOSTabBar *tabBar;


@end
