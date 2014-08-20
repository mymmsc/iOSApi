//
//  UIView+Utils.m
//  iOSApi
//
//  Created by  on 12-1-13.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "UIView+Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Utils)

- (void)addShadow{
	// 0.8 is a good feeling shadowOpacity
	self.layer.shadowOpacity = 0.8;
	
	// The Width and the Height of the shadow rect
	CGFloat rectWidth = 1.0;
	CGFloat rectHeight = self.frame.size.height;
	
	// Creat the path of the shadow
	CGMutablePathRef shadowPath = CGPathCreateMutable();
	// Move to the (0, 0) point
	CGPathMoveToPoint(shadowPath, NULL, 0.0, 0.0);
	// Add the Left and right rect
	CGPathAddRect(shadowPath, NULL, CGRectMake(0.0 - rectWidth, 0.0, rectWidth, rectHeight));
	CGPathAddRect(shadowPath, NULL, CGRectMake(self.frame.size.width, 0.0, rectWidth, rectHeight));
	CGPathAddRect(shadowPath, NULL, CGRectMake(0.0, 0.0 - rectWidth, self.frame.size.width, rectWidth));
	CGPathAddRect(shadowPath, NULL, CGRectMake(0.0, self.frame.size.height, self.frame.size.width,rectWidth));
    
	self.layer.shadowPath = shadowPath;
	CGPathRelease(shadowPath);
	// Since the default color of the shadow is black, we do not need to set it now
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	
	self.layer.shadowOffset = CGSizeMake(0, 0);
	// This is very important, the shadowRadius decides the feel of the shadow
	self.layer.shadowRadius = 2.0;
}

@end
