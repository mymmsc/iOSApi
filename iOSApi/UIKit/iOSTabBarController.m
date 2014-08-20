//
//  iOSTabBarController.m
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSTabBarController.h"
#import "iOSTabBar.h"
#import "iOSTab.h"
#import <iOSApi/UINavigationController+icons.h>
#import "UIViewController_TabBar.h"
#import "iOSTabBarView.h"

@interface iOSTabBarController ()

- (void)loadTabs;

@property (nonatomic, retain) UIImageView *selectedTab;
@property (nonatomic, readwrite) BOOL visible;

@end


@implementation iOSTabBarController
@synthesize viewControllers=_viewControllers, tabBar, selectedTab, selectedViewController, tabBarView, visible;

- (void)loadView {
	self.tabBarView = [[[iOSTabBarView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view = self.tabBarView;

	CGFloat tabBarHeight = 44 + 6; // tabbar + arrow
	CGFloat adjust = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 1 : 0;
	self.tabBar = [[[iOSTabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - tabBarHeight, self.view.bounds.size.width, tabBarHeight + adjust)] autorelease];
	self.tabBar.delegate = self;
	
	self.tabBarView.backgroundColor = [UIColor clearColor];
	self.tabBarView.tabBar = self.tabBar;
	[self loadTabs];
	
	UIViewController *tmp = selectedViewController;
	selectedViewController = nil;
	[self setSelectedViewController:tmp];
}

- (void)tabBar:(iOSTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index {
	UIViewController *vc = [_viewControllers objectAtIndex:index];
	if (self.selectedViewController == vc) {
		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
		}
	} else {
		self.selectedViewController = vc;
	}
}

- (void)setSelectedViewController:(UIViewController *)vc {
	UIViewController *oldVC = selectedViewController;
	if (selectedViewController != vc) {
		selectedViewController = vc;
        if (!self.childViewControllers && visible) {
			[oldVC viewWillDisappear:NO];
			[selectedViewController viewWillAppear:NO];
		}
		self.tabBarView.contentView = vc.view;
        if (!self.childViewControllers && visible) {
			[oldVC viewDidDisappear:NO];
			[selectedViewController viewDidAppear:NO];
		}
		
		[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:(oldVC != nil)];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewDidAppear:animated];
    
	visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
	visible = NO;
}



- (NSUInteger)selectedIndex {
	return [_viewControllers indexOfObject:self.selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	if (_viewControllers.count > aSelectedIndex)
		self.selectedViewController = [_viewControllers objectAtIndex:aSelectedIndex];
}

- (void)loadTabs {
	NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:_viewControllers.count];
	for (UIViewController *vc in _viewControllers) {
		[tabs addObject:[[[iOSTab alloc] initWithIconImageName:[vc iconName]]autorelease]];
	}
	self.tabBar.tabs = [tabs retain];
	[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:NO];
}

- (void)viewDidUnload {
	self.tabBar = nil;
	self.selectedTab = nil;
}

- (void)setViewControllers:(NSArray *)array {
	if (array != _viewControllers) {
		_viewControllers = array;
		
		if (_viewControllers != nil) {
			[self loadTabs];
		}
	}
	
	self.selectedIndex = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
