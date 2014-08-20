//
//  iOSTableViewController.h
//  iOSApi
//
//  Created by WangFeng on 11-11-12.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSRefreshTableView.h"

#define CELL_CONTENT_WIDTH 270.0f
#define CELL_CONTENT_MARGIN 5.0f

@protocol iOSTableDataDelegate;

@interface iOSTableViewController : UIViewController< UITableViewDelegate, UITableViewDataSource, iOSRefreshTableViewDelegate>
{
    NSMutableArray              *_dataArray;
    iOSRefreshTableView         *_refreshView;
    //int                          _page; // 当前页数
    //int                          _size; // 每页记录数
    iOSRefreshTableViewPullType  _pullType;
    NSMutableArray              *_listMore;
    NSMutableDictionary         *_downloads;
    NSMutableDictionary         *_images;
}

@property (nonatomic, assign) id<iOSTableDataDelegate> proxy;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
//@property (nonatomic, retain) NSMutableArray *dataArray;
//@property (nonatomic, assign) int pageNum, pageSize;

- (id)objectForEvent:(id)event;
- (void)reloadData;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath;

@end


@protocol iOSTableDataDelegate <NSObject>

- (NSArray *)reloadData:(iOSTableViewController *)tableView;
- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView;
- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView;

@optional
// 可选 数据接口
- (UITableViewCell *)configure:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)configure:(UITableViewCell *)cell withObject:(id)object;
// 可选 动作接口
- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object;

@end