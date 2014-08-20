//
//  iOSRefreshTableView.m
//  iOSApi
//
//  Created by WangFeng on 11-12-9.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSRefreshTableView.h"

@interface iOSRefreshTableView()

- (void) initControl;

- (void) initPullDownView;
- (void) initPullUpView;
- (void) initPullAllView;

- (void) updatePullViewFrame;

@end

@implementation iOSRefreshTableView

@synthesize pullTableView = _pullTableView;
@synthesize delegate = _delegate;

- (id) initWithTableView:(UITableView *)tView 
           pullDirection:(iOSRefreshTableViewDirection) cwDirection
{
    if ((self = [super init])) {
        _pullTableView = tView;
        _direction = cwDirection;
        [self initControl];
    }
    
    return self;
}

#pragma mark private
- (void) initControl
{
    switch (_direction) {
        case iOSRefreshTableViewDirectionUp:
            [self initPullUpView];
            break;
        case iOSRefreshTableViewDirectionDown:
            [self initPullDownView];
            break;
        case iOSRefreshTableViewDirectionAll:
            [self initPullAllView];
            break;
    }
}

- (void)initPullDownView
{
    CGFloat fWidth = _pullTableView.frame.size.width;
    /*CGFloat originY = _pullTableView.contentSize.height;
    if (originY < _pullTableView.frame.size.height) {
        originY = _pullTableView.frame.size.height;
    }*/
    
    RefreshTableHeaderView *view = [[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -kRefreshHeight, fWidth, kRefreshHeight) byDirection:kPullRefreshDown];
    view.delegate = self;
    //view.groupHeight = _pullTableView.style == UITableViewStyleGrouped ? kRefreshHeight: 0;
    [_pullTableView addSubview:view];
    view.autoresizingMask = _pullTableView.autoresizingMask;
    _headView = view;
    [view release];
    
    [_headView refreshLastUpdatedDate];
}

- (void)initPullUpView
{
    CGFloat fWidth = _pullTableView.frame.size.width;
    if (_pullTableView.style == UITableViewStyleGrouped) {
        //fWidth = fWidth - kRefreshHeight;
    }
    
    CGFloat originY = _pullTableView.contentSize.height;
    CGFloat originX = _pullTableView.contentOffset.x;
    if (originY < _pullTableView.frame.size.height) {
        originY = _pullTableView.frame.size.height;
    }
    
    RefreshTableHeaderView *view = [[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(originX, originY, fWidth, kRefreshHeight) byDirection:kPullRefreshUp];
    view.delegate = self;
    //view.groupHeight = _pullTableView.style == UITableViewStyleGrouped ? kRefreshHeight: 0;
    [_pullTableView addSubview:view];
    view.autoresizingMask = _pullTableView.autoresizingMask;
    _footerView = view;
    [view release]; 
    
    [_footerView refreshLastUpdatedDate];
}

- (void)initPullAllView
{
    [self initPullUpView];
    [self initPullDownView];
}


- (void)updatePullViewFrame
{
    if (_headView != nil) {
        
    }
    if (_footerView != nil) {
        CGFloat fWidth = _pullTableView.frame.size.width;
        CGFloat originY = _pullTableView.contentSize.height;
        CGFloat originX = _pullTableView.contentOffset.x;
        if (originY < _pullTableView.frame.size.height) {
            originY = _pullTableView.frame.size.height;
        }
        if (!CGRectEqualToRect(_footerView.frame, CGRectMake(originX, originY, fWidth, kRefreshHeight))) {
            _footerView.frame = CGRectMake(originX, originY, fWidth, kRefreshHeight);  
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //CGFloat offset = scrollView.contentOffset.y - scrollView.frame.origin.y;
    if (scrollView.contentOffset.y < 0) {
        [_headView refreshScrollViewDidScroll:scrollView];  
    } else if (scrollView.contentOffset.y > 0) {
        [_footerView refreshScrollViewDidScroll:scrollView];
    }
    
    [self updatePullViewFrame];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < -kRefreshHeight) {
        [_headView refreshScrollViewDidEndDragging:scrollView];  
    } else if (scrollView.contentOffset.y > kRefreshHeight) {
        [_footerView refreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)DataSourceDidFinishedLoading
{
    _reloading = NO;
    [_headView refreshScrollViewDataSourceDidFinishedLoading:_pullTableView];
    [_footerView refreshScrollViewDataSourceDidFinishedLoading:_pullTableView];
}

- (void)setFooterViewFrame:(CGRect)frame{
    _footerView.frame = frame;
}

#pragma mark -
#pragma mark RefreshTableHeaderDelegate Methods

- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView *)view 
                                  direction:(PullRefreshDirection)direc{
	if (_delegate != nil && [_delegate respondsToSelector:@selector(iOSRefreshTableViewReloadTableViewDataSource:)]) {
        if (direc == kPullRefreshUp) {
            _reloading = [_delegate iOSRefreshTableViewReloadTableViewDataSource:iOSRefreshTableViewPullTypeLoadMore]; 
        } else if (direc == kPullRefreshDown) {
            _reloading = [_delegate iOSRefreshTableViewReloadTableViewDataSource:iOSRefreshTableViewPullTypeReload];
        }
    }
}

- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView *)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate *)refreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView *)view{
	return [NSDate date]; // should return date data source was last changed
}

@end