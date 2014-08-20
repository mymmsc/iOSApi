//
//  iOSRefreshTableView.h
//  iOSApi
//
//  Created by WangFeng on 11-12-9.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "RefreshTableHeaderView.h"

//pull direction
typedef enum {
    iOSRefreshTableViewDirectionUp,
    iOSRefreshTableViewDirectionDown,
    iOSRefreshTableViewDirectionAll
}iOSRefreshTableViewDirection;

//pull type

typedef enum {
    iOSRefreshTableViewPullTypeReload,           //从新加载
    iOSRefreshTableViewPullTypeLoadMore,         //加载更多
}iOSRefreshTableViewPullType;

@protocol iOSRefreshTableViewDelegate;

@interface iOSRefreshTableView : NSObject<RefreshTableHeaderDelegate, UIScrollViewDelegate>
{
    BOOL                         _reloading;
    RefreshTableHeaderView      *_headView;
    RefreshTableHeaderView      *_footerView;
    
    iOSRefreshTableViewDirection _direction;
}

@property (nonatomic, assign) UITableView *pullTableView;
@property (nonatomic, assign) id<iOSRefreshTableViewDelegate> delegate;

//方向
- (id) initWithTableView:(UITableView *) tView
           pullDirection:(iOSRefreshTableViewDirection) cwDirection;

//加载完成调用
- (void)DataSourceDidFinishedLoading;
- (void)setFooterViewFrame:(CGRect)frame;
@end


//
@protocol iOSRefreshTableViewDelegate <NSObject>

//从新加载
- (BOOL) iOSRefreshTableViewReloadTableViewDataSource:(iOSRefreshTableViewPullType)refreshType;

@end