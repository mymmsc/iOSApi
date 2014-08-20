//
//  iOSApi+Window.m
//  iOSApi
//
//  Created by WangFeng on 11-12-11.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSApi+Window.h"
#import "iOSActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "iOSToast.h"

#define IOSAPI_WINDOW_TAG (10000)

@implementation iOSApi (Window)

+ (void) Alert:(NSString *)title
       message:(NSString *)message {
	UIAlertView *view =[[UIAlertView alloc]initWithTitle:title
												 message:message
												delegate:self 
									   cancelButtonTitle:@"确定"
									   otherButtonTitles:nil];
	[view show];
    [view release];
}

static UIAlertView *s_imageView = nil;
static int          s_imageTag = IOSAPI_WINDOW_TAG + 1;

//static UIActivityIndicatorView *s_imageActivityView = nil;

+(void)onImageClose:(id)sender /*event:(id)event*/{
    if (s_imageView != nil) {
		//[NSThread sleepForTimeInterval: 1.0];
		[s_imageView dismissWithClickedButtonIndex: 0 animated: NO];
		[s_imageView release];
	}
}

+ (void)showImage:(NSString *)uri {
    s_imageView = [[UIAlertView alloc]
                   initWithTitle:@""
                   message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                   delegate:self
                   cancelButtonTitle:nil
                   otherButtonTitles:nil];
    //CGRect frame = CGRectMake(38, 10, 210, 280);
	CGRect frame = CGRectMake(0, 0, 280, 350);
    s_imageView.frame = frame;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [s_imageView addSubview:scrollView];
    [scrollView release];
    NSString *tmpUrl = [uri stringByReplacingOccurrencesOfString:@"_zoomout" withString:@""];
	UIImage *im = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpUrl]]] autorelease];
    //im.size
    scrollView.contentSize = im.size;//CGSizeMake(scrollView.frame.size.width*widthN, 66.0f);
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = NO;
    //scrollView.delegate = self;
    UIImageView *image = [[[UIImageView alloc] initWithImage: im] autorelease];
    image.tag = s_imageTag;
	[scrollView addSubview: image];
	//image.frame = frame;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:@"close.png"];
    [closeButton setFrame: CGRectMake(250, -20, 50, 50)];
    [closeButton setImage:btnImage forState:UIControlStateNormal];
	[closeButton setImage:btnImage forState:UIControlStateSelected];
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton addTarget:self action:@selector(onImageClose:/*event:*/) forControlEvents:UIControlEventTouchUpInside];
    [s_imageView addSubview:closeButton];
	[image setNeedsLayout];
	[s_imageView show];
}
/*
+ (void)willPresentAlertView:(UIAlertView *)alertView
{
    [alertView setFrame:CGRectMake( 0, 40, 50, 50)];
    [alertView setBounds:CGRectMake( 0, -120, 50, 50)];
    //UIImageView *image = (UIImageView *)[alertView viewWithTag:s_imageTag];
    //[image setNeedsLayout];
}
 */

+ (void)showImage2:(NSString *)uri view:(UIViewController *)view view2:(UIViewController *)contentViewController {
    //UIViewController* controller = self.view.window.rootViewController;
    //controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    contentViewController.view.frame = CGRectMake(60, 60, 210, 280);
    contentViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    contentViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    view.modalPresentationStyle = UIModalPresentationFormSheet;
    view.modalInPopover = YES;
    contentViewController.modalInPopover = YES;
    //[controller presentModalViewController:v animated:YES];
    [view presentModalViewController:contentViewController animated:YES];
}

+ (void)showImage2:(NSString *)uri view:(UIViewController *)controller{
    NSString *tmpUrl = [uri stringByReplacingOccurrencesOfString:@"_zoomout" withString:@""];
	UIImage *im = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpUrl]]] autorelease];
    
    UIImageView *fullScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    fullScreen.alpha = 0.7;
    //fullScreen.image = [[UIImage imageNamed:@"app_bg.png"] autorelease];
    fullScreen.backgroundColor = [UIColor grayColor];
    UIButton *hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hiddenButton setFrame: CGRectMake(0, 0, 320, 460)];
    hiddenButton.backgroundColor = [UIColor clearColor];
    [hiddenButton addTarget:self action:@selector(onImageClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [controller.view addSubview:hiddenButton];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 64.0, 64.0)];  
    image.image = im;
    CALayer * layer = [image layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
    [fullScreen addSubview:image];
    [image release];
    [controller.view addSubview:fullScreen];
    [controller.view bringSubviewToFront:fullScreen];
    [fullScreen release];
}

// 线程函数, 必须使用内存池管理
+ (void)startWaiting:(NSString*) message {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [[iOSActivityIndicator currentIndicator] displayActivity:message];
    [pool release];
}

+ (void)showAlert:(NSString *)message {
    [NSThread detachNewThreadSelector:@selector(startWaiting:) toTarget:self withObject:message];
}

+ (void)showCompleted:(NSString *)message {
    [[iOSActivityIndicator currentIndicator] displayCompleted:message];
}

+ (void)closeAlert{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [[iOSActivityIndicator currentIndicator] hideAfterDelay];
    [pool release];
}

// 显示短暂的消息
+ (void)toast:(NSString *)message{
    [iOSToast show:message];
}

@end
