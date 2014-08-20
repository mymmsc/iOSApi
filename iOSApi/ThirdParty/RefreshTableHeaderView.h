//
//  RefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  修改人：禚来强 iphone开发qq群：79190809 邮箱：zhuolaiqiang@gmail.com
//


#import <iOSApi/iOSApi+UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kRefreshHeight (44.0f) // 拖拽高度

typedef enum PullRefreshState {
	kPullRefreshPulling = 0, // 拖拽中
	kPullRefreshNormal,      // 一般状态
	kPullRefreshLoading,     // 加载中
} PullRefreshState;

typedef enum PullRefreshDirection{
    kPullRefreshUp, // 向上提
    kPullRefreshDown // 向下拉
}PullRefreshDirection;

@protocol RefreshTableHeaderDelegate;
@interface RefreshTableHeaderView : UIView {
	
	id                       _delegate;
	PullRefreshState         _state;
    PullRefreshDirection     _direction;
    
	UILabel                 *_lastUpdatedLabel;
	UILabel                 *_statusLabel;
	CALayer                 *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
}

@property(nonatomic,assign) CGFloat groupHeight;
@property(nonatomic,assign) id <RefreshTableHeaderDelegate> delegate;
@property(nonatomic,assign) PullRefreshDirection direction;

- (id) initWithFrame:(CGRect)frame byDirection:(PullRefreshDirection) direc;

- (void)refreshLastUpdatedDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

//----------------------------------------
@protocol RefreshTableHeaderDelegate

@optional
- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView *)view
                                  direction:(PullRefreshDirection) direc;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView *)view;

@optional
- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView *)view;

@end
