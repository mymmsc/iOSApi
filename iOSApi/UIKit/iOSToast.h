//
//  iOSToast.h
//  iOSApi
//
//  Created by WangFeng on 11-11-1.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi+UIKit.h>
/*--------------------< iOSToast class BEGIN >--------------------*/

typedef enum iOSToastGravity {
	iOSToastGravityTop = 1000001,
	iOSToastGravityBottom,
	iOSToastGravityCenter
}iOSToastGravity;

typedef enum iOSToastDuration {
	iOSToastDurationLong = 10000,
	iOSToastDurationShort = 1000,
	iOSToastDurationNormal = 3000
}iOSToastDuration;

typedef enum iOSToastType {
	iOSToastTypeInfo = -100000,
	iOSToastTypeNotice,
	iOSToastTypeWarning,
	iOSToastTypeError
}iOSToastType;


@class iOSToastSettings;

@interface iOSToast : NSObject {
	iOSToastSettings *_settings;
	NSInteger offsetLeft;
	NSInteger offsetTop;
	
	NSTimer *timer;
	
	UIView *view;
	NSString *text;
}

+ (void)show:(NSString *)message;

- (void)show;

- (iOSToast *)setDuration:(NSInteger ) duration;
- (iOSToast *)setGravity:(iOSToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			 offsetTop:(NSInteger) top;
- (iOSToast *)setGravity:(iOSToastGravity) gravity;
- (iOSToast *)setPostion:(CGPoint) position;

+ (iOSToast *)makeText:(NSString *) text;

- (iOSToastSettings *) theSettings;

@end

/*--------------------< iOSToast class END >--------------------*/

/*--------------------< iOSToastSettings class BEGIN >--------------------*/

@interface iOSToastSettings : NSObject<NSCopying>{
	NSInteger       duration;
	iOSToastGravity gravity;
	CGPoint         postition;
	iOSToastType    toastType;
	
	NSDictionary   *images;
	
	BOOL            positionIsSet;
}

@property(assign) NSInteger duration;
@property(assign) iOSToastGravity gravity;
@property(assign) CGPoint postition;
@property(readonly) NSDictionary *images;


- (void)setImage:(UIImage *)img forType:(iOSToastType) type;
+ (iOSToastSettings *) getSharedSettings;
						  
@end

/*--------------------< iOSToastSettings class END >--------------------*/
