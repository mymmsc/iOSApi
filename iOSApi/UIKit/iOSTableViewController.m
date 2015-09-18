//
//  iOSTableView2.m
//  iOSApi
//
//  Created by WangFeng on 11-11-12.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSTableViewController.h"
#import "HttpDownloader.h"

@implementation iOSTableViewController
@synthesize proxy;
@synthesize tableView=_tableView;
//@synthesize dataArray = _dataArray;
//@synthesize pageNum = _page, pageSize = _size;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.tableView.refreshView.delegate = self;
        //_tableView.refreshView.delegate = self;
    }
    return self;
}

// 如果内存警告, 需要在此处理释放
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    // terminate all pending download connections
    NSArray *allDownloads = [_downloads allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _refreshView = [[iOSRefreshTableView alloc] initWithTableView:self.tableView pullDirection:iOSRefreshTableViewDirectionAll];
    _refreshView.delegate = self;
    _downloads = [[NSMutableDictionary alloc] initWithCapacity:0];
    _images = [[NSMutableDictionary alloc] initWithCapacity:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.tableView = nil;
}

- (void)dealloc {
    IOSAPI_RELEASE(_dataArray);
	IOSAPI_RELEASE(_refreshView);
    IOSAPI_RELEASE(_listMore);
    IOSAPI_RELEASE(_downloads);
    IOSAPI_RELEASE(_images);
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// 页面加载完毕后, 读取数据
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (_dataArray.count == 0) {
        [self reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (id)objectForEvent:(id)event{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView: self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    return [_dataArray objectAtIndex:indexPath.row];
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath{
    return [_dataArray objectAtIndex:indexPath.row];
}

- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath{
    return [_images objectForKey:indexPath];
}

- (void)reloadData {
    NSArray *list = [proxy reloadData:self];
    if (_dataArray.count > 0) {
        [_dataArray removeAllObjects];
    }
    [list retain];
    [_dataArray addObjectsFromArray:list];
    [list release];
    [self.tableView reloadData];
    [self performSelector:@selector(reloadOk) withObject:nil afterDelay:0.5];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_dataArray count];
}

// 计算文本内容所占高度
- (CGFloat)heightForText:(UILabel*)label{
    NSString *text = label.text;
    UIFont *font = label.font;
    if (font.pointSize == 0) {
        // 系统默认尺寸为17
        font = [UIFont systemFontOfSize:17];
    }
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

// 给出UITableViewCell高度, 高度自适应
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell.frame.size.height > 50) {
        return cell.frame.size.height;
    }
    CGFloat height = [self heightForText:cell.textLabel];
    height += [self heightForText:cell.detailTextLabel];
    //iOSLog(@"cell height is %.f at %d", height, [indexPath row]);
    height = MAX(height, 10.0f);
    height += (CELL_CONTENT_MARGIN * 2);
    if (cell.imageView.image != nil) {
        float imageHeight = cell.imageView.frame.size.height;
        height = MAX(height, imageHeight + 6.0f);
    }
    height = MAX(height, 50.0f);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([proxy respondsToSelector:@selector(configure:atIndexPath:)]) {
        return [proxy configure:tableView atIndexPath:indexPath];
    } else {
        static NSString *identifier = @"Cell";
        
        int pos = (int)[indexPath row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        }
        
        UITableViewCell *cellView = [proxy configure:cell withObject:[_dataArray objectAtIndex:pos]];
        if (cell != cellView) {
            cell = cellView;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([proxy respondsToSelector:@selector(tableView:onCustomAccessoryTapped:)]) {
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [proxy tableView:cell onCustomAccessoryTapped:[_dataArray objectAtIndex:indexPath.row]];
    }
}

#pragma mark -
#pragma mark Table cell image support

- (void)startImageDownload:(NSString *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    HttpDownloader *downloader = [_downloads objectForKey:indexPath];
    if (downloader == nil) 
    {
        downloader = [[HttpDownloader alloc] init];
        //downloader.appRecord = appRecord;
        downloader.target = indexPath;
        downloader.delegate = self;
        [_downloads setObject:downloader forKey:indexPath];
        [downloader bufferFromURL:[NSURL URLWithString:appRecord]];
        [downloader release];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([_downloads count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            id obj = [_dataArray objectAtIndex:indexPath.row];
            SEL aSel = NSSelectorFromString(@"imageUrl");
            if ([obj respondsToSelector:aSel]) {
                IMP func = [obj methodForSelector:aSel];
                NSString *imageUrl = func(obj, aSel);
                [self startImageDownload:imageUrl forIndexPath:indexPath];
            }
        }
    }
}

// called by our HttpDownloader when an icon is ready to be displayed
- (BOOL)httpDownloader:(HttpDownloader *)downloader didFinished:(NSMutableData *)buffer target:(id)target{
    //HttpDownloader *downloader = [_downloads objectForKey:target];
    if (downloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:downloader.target];
        [_images setObject:[UIImage imageWithData:buffer] forKey:target];
        // Display the newly loaded image
        cell.imageView.image = [_images objectForKey:target];
    }
    return YES;
}

#pragma mark scroll view delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView scrollViewDidScroll:scrollView];
    [self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

#pragma mark scroll view delegate
- (BOOL)iOSRefreshTableViewReloadTableViewDataSource_OLD:(iOSRefreshTableViewPullType)refreshType
{
    switch (refreshType) {
        case iOSRefreshTableViewPullTypeReload: {
            NSArray *list = [proxy arrayOfHeader:self];
            [list retain];
            for (NSObject *obj in list) {
                [_dataArray insertObject: obj atIndex: 0];
            }
            [list release];
            [self.tableView reloadData];
            break;
        }
        case iOSRefreshTableViewPullTypeLoadMore:{
            NSArray *list = [proxy arrayOfFooter:self];
            [list retain];
            [_dataArray addObjectsFromArray:list];
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:0];
            for (int ind = 0; ind < [list count]; ind++) {
                NSIndexPath *newPath = [NSIndexPath indexPathForRow:[_dataArray indexOfObject:[list objectAtIndex:ind]] inSection:0];
                [insertIndexPaths addObject:newPath];
            }
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [list release];
            [self.tableView reloadData];
            break;
        }
    }
    [self performSelector:@selector(reloadOk) withObject:nil afterDelay:0.5];
    return YES;
}

- (void)reloadTableViewDataSource{
    switch (_pullType) {
        case iOSRefreshTableViewPullTypeReload: {
            NSArray *list = [proxy arrayOfHeader:self];
            if(list != nil) {
                [list retain];
                for (NSObject *obj in list) {
                    [_dataArray insertObject: obj atIndex: 0];
                }
                [list release];
                //[self.tableView reloadData];
            }
            break;
        }
        case iOSRefreshTableViewPullTypeLoadMore:{
            NSArray *list = [proxy arrayOfFooter:self];
            if (list != nil) {
                [list retain];
                [_dataArray addObjectsFromArray:list];
                /*
                 if (_listMore != nil) {
                 [_listMore release];
                 }
                 _listMore = [[NSMutableArray alloc] initWithCapacity:0];
                 [_listMore addObjectsFromArray:list];
                 */
                [list release];
                //[self.tableView reloadData];
            }
            break;
        }
    }
    
    //[self performSelector:@selector(reloadOk) withObject:nil afterDelay:0.3];
    //回到主线程跟新界面
	[self performSelectorOnMainThread:@selector(dosomething) withObject:nil waitUntilDone:YES];
}

- (BOOL)iOSRefreshTableViewReloadTableViewDataSource:(iOSRefreshTableViewPullType)refreshType
{
    _pullType = refreshType;
    //[self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:0.5];
    //打开线程，读取网络数据
	[NSThread detachNewThreadSelector:@selector(reloadTableViewDataSource) toTarget:self withObject:nil];
    return YES;
}

-(void)dosomething
{
    CGFloat offset = self.tableView.frame.size.height - self.tableView.contentSize.height;
    iOSLog(@"offset = %.2f", offset);
    if (_pullType == iOSRefreshTableViewPullTypeLoadMore && offset < 0) {
        if (offset < 0) {
            CGSize tmpSize = self.tableView.contentSize;
            tmpSize.height += kRefreshHeight;
            CGRect tmpFrame = self.tableView.frame;
            tmpFrame.origin.y = tmpSize.height;
            [_refreshView setFooterViewFrame:tmpFrame];
        }
        /*
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:0];
        for (int ind = 0; ind < [_listMore count]; ind++) {
            NSIndexPath *newPath = [NSIndexPath indexPathForRow:[_array indexOfObject:[_listMore objectAtIndex:ind]] inSection:0];
            [insertIndexPaths addObject:newPath];
        }
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [_listMore release];
        _listMore = nil;
        */
    }
	[self.tableView reloadData];
    [self performSelector:@selector(reloadOk) withObject:nil afterDelay:1.5];
}

- (void)reloadOk
{
    [_refreshView DataSourceDidFinishedLoading];
}

@end
