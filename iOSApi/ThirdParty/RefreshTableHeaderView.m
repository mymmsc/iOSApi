//
//  RefreshTableHeaderView.m
//  Demo
//
//  修改人：禚来强 iphone开发qq群：79190809 邮箱：zhuolaiqiang@gmail.com
//


#import "RefreshTableHeaderView.h"

#define kDragViewHeight 10.0f
#define kAnimationDuration 0.3f


#define TEXT_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface RefreshTableHeaderView (Private)
- (void)initControl;
- (void)setState:(PullRefreshState)aState;
@end

@implementation RefreshTableHeaderView

@synthesize delegate = _delegate;
@synthesize direction = _direction;
@synthesize groupHeight = _groupHeight;

- (id)initWithFrame:(CGRect)frame byDirection:(PullRefreshDirection)direc
{
    if ((self = [super initWithFrame:frame])) {
        _direction = direc;
        [self initControl];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        _direction = kPullRefreshUp; //默认上拉刷新
		[self initControl];
    }
    return self;
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate refreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:NSLocalizedString(@"上午", nil)];
		[formatter setPMSymbol:NSLocalizedString(@"下午", nil)];
		[formatter setDateFormat:@"yyyy/MM/dd hh:mm:a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
        
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"RefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		_lastUpdatedLabel.text = nil;
	}

}

- (void)initControl
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    // 透明
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, kRefreshHeight - 22.0f, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = TEXT_COLOR;
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    _lastUpdatedLabel=label;
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 2.0f, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.textColor = TEXT_COLOR;
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    _statusLabel=label;
    [label release];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(25.0f, kRefreshHeight - kRefreshHeight, 30.0f, kRefreshHeight);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents = (id)[UIImage imageNamed:@"RefreshTable.bundle/blueArrow.png"].CGImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    
    [[self layer] addSublayer:layer];
    _arrowImage = layer;
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.frame = CGRectMake(25.0f, kRefreshHeight - 21.0f, 20.0f, 20.0f);
    [self addSubview:view];
    _activityView = view;
    [view release];
    
    [self setState:kPullRefreshNormal];
}

- (void)setState:(PullRefreshState)aState{
	switch (aState) {
		case kPullRefreshPulling:
			_statusLabel.text = NSLocalizedString(@"松开即可更新...", @"松开即可更新...");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
		case kPullRefreshNormal:
			if (_state == kPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			// 改变状态信息
            switch (_direction) {
                case kPullRefreshUp:
                    _statusLabel.text = NSLocalizedString(@"上拉即可更新...", @"上拉即可更新...");
                    break;
                case kPullRefreshDown:
                    _statusLabel.text = NSLocalizedString(@"下拉即可更新...", @"下拉即可更新...");
                    break;
            }
            
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case kPullRefreshLoading:
			_statusLabel.text = NSLocalizedString(@"加载中...", @"加载中...");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    //iOSLog(@"contentOffset y = %.2f", scrollView.contentOffset.y);
	if (_state == kPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, kRefreshHeight);
        switch (_direction) {
            case kPullRefreshUp:
                if (scrollView.contentSize.height < scrollView.frame.size.height) {
                    scrollView.contentInset = UIEdgeInsetsMake(-kRefreshHeight, 0.0f, 0.0f, 0.0f);
                } else {
                    scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, kRefreshHeight, 0.0f);  
                }
                //iOSLog(@"kPullRefreshLoading-kPullRefreshUp: offset = %.2f", offset);
                break;
            case kPullRefreshDown:
                scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
                //iOSLog(@"kPullRefreshLoading-kPullRefreshDown: offset = %.2f", offset);
                break;
        }
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
        CGFloat offset = scrollView.frame.size.height - scrollView.contentSize.height;
		if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
		}
		//iOSLog(@"isDragging: offset = %.2f, %.2f", offset, scrollView.contentOffset.y);
        switch (_direction) {
            case kPullRefreshUp:
                /*if (_state == kPullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + kRefreshHeight && scrollView.contentOffset.y > 0.0f && !_loading) {
                    [self setState:kPullRefreshNormal];
                } else if (_state == kPullRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + kRefreshHeight  && !_loading) {
                    [self setState:kPullRefreshPulling];
                }*/
                if((offset + scrollView.contentOffset.y) > kRefreshHeight){
                    offset = 0;
                }
                //iOSLog(@"isDragging: offset = %.2f, %.2f", offset, scrollView.contentOffset.y);
                if (_state == kPullRefreshPulling && (scrollView.contentOffset.y + offset) < kRefreshHeight && scrollView.contentOffset.y > 0.0f && !_loading) {
                    [self setState:kPullRefreshNormal];
                } else if (_state == kPullRefreshNormal && (scrollView.contentOffset.y + offset) >= kRefreshHeight && !_loading) {
                    [self setState:kPullRefreshPulling];
                }
                break;
                
            case kPullRefreshDown:
                if (_state == kPullRefreshPulling && scrollView.contentOffset.y > -kRefreshHeight && scrollView.contentOffset.y < 0.0f && !_loading) {
                    [self setState:kPullRefreshNormal];
                } else if (_state == kPullRefreshNormal && scrollView.contentOffset.y < -kRefreshHeight && !_loading) {
                    [self setState:kPullRefreshPulling];
                }
                break;
        }
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	//iOSLog(@"contentOffset y = %.2f", scrollView.contentOffset.y);
    CGFloat offset = scrollView.frame.size.height - scrollView.contentSize.height;
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
	}
    switch (_direction) {
        case kPullRefreshUp:
            if((offset + scrollView.contentOffset.y) > kRefreshHeight){
                offset = 0;
            }
            if (scrollView.contentOffset.y + offset >= kRefreshHeight && !_loading) {
                
                if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:direction:)]) {
                    [self setState:kPullRefreshLoading];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:kAnimationDuration];
                    if (scrollView.contentSize.height < scrollView.frame.size.height) {
                        scrollView.contentInset = UIEdgeInsetsMake(-kRefreshHeight, 0.0f, 0.0f, 0.0f);
                    } else {
                        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, kRefreshHeight, 0.0f);  
                    }
                    //iOSLog(@"kPullRefreshUp: contentOffset y = %.2f, 0,0,44,0", scrollView.contentOffset.y);
                    [UIView commitAnimations];
                    
                    //[self performSelectorOnMainThread:@selector(LoadDataSource) withObject:nil waitUntilDone:NO];
                    [_delegate refreshTableHeaderDidTriggerRefresh:self direction:_direction];
                }
            }
            break;
        case kPullRefreshDown:
            if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
                _loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
            }
            
            if (scrollView.contentOffset.y <= -kRefreshHeight && !_loading) {
                if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:direction:)]) {
                    [self setState:kPullRefreshLoading];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:kAnimationDuration];
                    scrollView.contentInset = UIEdgeInsetsMake(kRefreshHeight - _groupHeight, 0.0f, 0.0f, 0.0f);
                    //iOSLog(@"kPullRefreshDown: contentOffset y = %.2f, 44,0,0,0", scrollView.contentOffset.y);
                    [UIView commitAnimations];
                    
                    //[self performSelectorOnMainThread:@selector(LoadDataSource) withObject:nil waitUntilDone:NO];
                    [_delegate refreshTableHeaderDidTriggerRefresh:self direction:_direction];
                }
            }
            break;
    }
}

- (void)LoadDataSource{
    [_delegate refreshTableHeaderDidTriggerRefresh:self direction:_direction];
}


//当开发者页面页面刷新完毕调用此方法，[delegate refreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	//iOSLog(@"数据刷新完毕。");
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kAnimationDuration];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:kPullRefreshNormal];

}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate = nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
