//
//  iOSTabBarView.m
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSTabBarView.h"
#import "iOSTabBar.h"

@implementation iOSTabBarView
@synthesize tabBar, contentView;

- (void)setTabBar:(iOSTabBar *)aTabBar {
    if (tabBar != aTabBar) {
        [tabBar removeFromSuperview];
        tabBar = aTabBar;
        [self addSubview:tabBar];
    }
}

- (void)setContentView:(UIView *)aContentView {
	[contentView removeFromSuperview];
	contentView = aContentView;
	contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.tabBar.frame.origin.y);

	[self addSubview:contentView];
	[self sendSubviewToBack:contentView];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = contentView.frame;
	f.size.height = self.tabBar.frame.origin.y;
	contentView.frame = f;
	[contentView layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	[RGBCOLOR(230, 230, 230) set];
	CGContextFillRect(c, self.bounds);
}

@end
