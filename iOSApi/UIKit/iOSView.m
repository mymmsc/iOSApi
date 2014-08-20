//
//  iOSView.m
//  iOSApi
//
//  Created by  on 12-1-6.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSView.h"
#import <QuartzCore/QuartzCore.h>

#define iOSdegreesToRadians(x) (M_PI * x / 180.0)

@implementation iOSView

#pragma mark -
#pragma mark Rotation

- (void)setProperRotation:(BOOL)animated
{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
	}
	
	if (orientation == UIDeviceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, iOSdegreesToRadians(180));
    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, iOSdegreesToRadians(90));	
	} else if (orientation == UIDeviceOrientationLandscapeRight) {
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, iOSdegreesToRadians(-90));
	}
	if (animated) {
		[UIView commitAnimations];
    }
}

- (void)setProperRotation
{
	[self setProperRotation:YES];
}

#pragma mark Creating Message

- (void)show
{	
	if ([self superview] != [[UIApplication sharedApplication] keyWindow]) {
		[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	}
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)hide
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hidden)];
	
	self.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)hidden
{
    if (self.alpha > 0) {
		return;
	}
	[self removeFromSuperview];
	//currentIndicator = nil;
}

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		self.opaque = NO;
		self.alpha = 0;
		self.layer.cornerRadius = 10;
		self.userInteractionEnabled = NO;
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleBottomMargin;
		
		[self setProperRotation:NO];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(setProperRotation)
													 name:UIDeviceOrientationDidChangeNotification
												   object:nil];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	
	// 释放资源
	
	[super dealloc];
}

@end
