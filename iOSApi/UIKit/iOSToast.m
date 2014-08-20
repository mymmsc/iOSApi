//
//  iOSToast.m
//  iOSApi
//
//  Created by WangFeng on 11-11-1.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSToast.h"
#import <QuartzCore/QuartzCore.h>

static iOSToastSettings *sharedSettings = nil;

@interface iOSToast(private)

- (iOSToast *) settings;

@end


@implementation iOSToast

- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
	}
	
	return self;
}

+ (void)show:(NSString *)message {
    iOSToast *toast = [iOSToast makeText:message];
    [toast show];
}

- (void)show{
	iOSToastSettings *theSettings = _settings;
	if (!theSettings) {
		theSettings = [iOSToastSettings getSharedSettings];
	}
	
	UIFont *font = [UIFont systemFontOfSize:16];
	CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = text;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(1, 1);
	
	UIButton *v = [[UIButton buttonWithType:UIButtonTypeCustom] autorelease];
	v.frame = CGRectMake(0, 0, textSize.width + 10, textSize.height + 10);
	label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
	[v addSubview:label];
	
	v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	v.layer.cornerRadius = 5;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	
	CGPoint point;// = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2);
	
	if (theSettings.gravity == iOSToastGravityTop) {
		point = CGPointMake(window.frame.size.width / 2, 45);
	}else if (theSettings.gravity == iOSToastGravityBottom) {
		point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
	}else if (theSettings.gravity == iOSToastGravityCenter) {
		point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
	}else{
		point = theSettings.postition;
	}
	
	point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
	v.center = point;
	
	NSTimer *timer1 = [NSTimer 
					   timerWithTimeInterval:((float)theSettings.duration)/1000 
					   target:self 
					   selector:@selector(hideToast:) 
					   userInfo:nil 
					   repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
	
	[window addSubview:v];
	view = [v retain];
	[v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (void) hideToast:(NSTimer*)theTimer{
	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
	
	NSTimer *timer2 = [NSTimer 
					   timerWithTimeInterval:500 
					   target:self 
					   selector:@selector(hideToast:) 
					   userInfo:nil 
					   repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
	[view removeFromSuperview];
}


+ (iOSToast *)makeText:(NSString *) _text{
	iOSToast *toast = [[[iOSToast alloc] initWithText:_text] autorelease];
	
	return toast;
}


- (iOSToast *)setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (iOSToast *)setGravity:(iOSToastGravity) gravity 
              offsetLeft:(NSInteger) left
               offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (iOSToast *) setGravity:(iOSToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (iOSToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(iOSToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[iOSToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation iOSToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iOSToastType) type{
	if (!images) {
		images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[images setValue:img forKey:key];
	}
}


+ (iOSToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [iOSToastSettings new];
		sharedSettings.gravity = iOSToastGravityTop;
		sharedSettings.duration = iOSToastDurationShort;
	}
	
	return sharedSettings;
	
}

- (id)copyWithZone:(NSZone *)zone{
	iOSToastSettings *copy = [iOSToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[images valueForKey:key] forType:[key intValue]];
	}
	
	return copy;
}

@end
