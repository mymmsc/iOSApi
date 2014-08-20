//
//  iOSTab.m
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSTab.h"
#import <iOSApi/UIImage+Utils.h>

@interface iOSTab ()
@property (nonatomic, retain) UIImage *rightBorder;
@property (nonatomic, retain) UIImage *background;
@end

@implementation iOSTab
@synthesize rightBorder, background;


- (id)initWithIconImageName:(NSString *)imageName {
    CGSize kSize = CGSizeMake(65, 50);
	if (self = [super init]) {
		self.adjustsImageWhenHighlighted = NO;
		self.background = [UIImage imageNamed:@"TabBarController.bundle/tab-background.png"];
		self.rightBorder = [UIImage imageNamed:@"TabBarController.bundle/tab-right-border.png"];
		self.backgroundColor = [UIColor clearColor];
		
		NSString *selectedName = [NSString stringWithFormat:@"%@-selected.%@",
								   [imageName stringByDeletingPathExtension],
								   [imageName pathExtension]];
		
		[self setImage:[[UIImage imageNamed:imageName] toSize:kSize] forState:UIControlStateNormal];
		[self setImage:[[UIImage imageNamed:selectedName] toSize:kSize] forState:UIControlStateSelected];
	}
	return self;
}

- (void)setHighlighted:(BOOL)aBool {
	// no highlight state
}

- (void)drawRect:(CGRect)rect {
	if (self.selected) {
		[background drawAtPoint:CGPointMake(0, 2)];
		[rightBorder drawAtPoint:CGPointMake(self.bounds.size.width - rightBorder.size.width, 2)];
		CGContextRef c = UIGraphicsGetCurrentContext();
		[RGBCOLOR(24, 24, 24) set]; 
		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
		[RGBCOLOR(14, 14, 14) set];		
		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
		CGContextFillRect(c, CGRectMake(self.bounds.size.width - 0.5, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
	}
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	UIEdgeInsets imageInsets = UIEdgeInsetsMake(floor((self.bounds.size.height / 2) -
												(self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
												(self.imageView.image.size.width / 2)),
												floor((self.bounds.size.height / 2) -
												(self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
												(self.imageView.image.size.width / 2)));
	self.imageEdgeInsets = imageInsets;
}

@end
