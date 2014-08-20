//
//  iOSActivityIndicator.h
//  iOSApi
//
//  Created by WangFeng on 11-11-1.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//
//

#import <iOSApi/iOSApi+UIKit.h>

@interface iOSActivityIndicator : UIView
{
	UILabel *centerMessageLabel;
	UILabel *subMessageLabel;
	
	UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) UILabel *centerMessageLabel;
@property (nonatomic, retain) UILabel *subMessageLabel;

@property (nonatomic, retain) UIActivityIndicatorView *spinner;


+ (iOSActivityIndicator *)currentIndicator;

- (void)show;
- (void)hideAfterDelay;
- (void)hide;
- (void)hidden;
- (void)displayActivity:(NSString *)m;
- (void)displayCompleted:(NSString *)m;
- (void)setCenterMessage:(NSString *)message;
- (void)setSubMessage:(NSString *)message;
- (void)showSpinner;
- (void)setProperRotation;
- (void)setProperRotation:(BOOL)animated;

@end
