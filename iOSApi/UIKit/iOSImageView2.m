//
//  iOSImageView.m
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import "iOSImageView2.h"

@implementation iOSImageView2

@synthesize delegate;

#define IOS_TAG_IMAGE_BASE  (99100)
#define IOS_TAG_IMAGE_VIEW  (IOS_TAG_IMAGE_BASE + 1)
#define IOS_TAG_IMAGE_IMAGE (IOS_TAG_IMAGE_BASE + 2)

#define IMAGE_MAX_WIDTH (210.0f)
#define IMAGE_SCALE (0.9f)

// 按钮点击事件
- (void) onImageClick:(id)sender event:(id)event {
	self.hidden = YES;
    if ([delegate respondsToSelector:@selector(imageViewWillClose:)]) {
        [delegate imageViewWillClose:self];
    }
    UIImageView *iv = (UIImageView *)[mainView viewWithTag:IOS_TAG_IMAGE_IMAGE];
    [iv removeFromSuperview];
    [self removeFromSuperview];
    self = nil;
}

- (id)initFromView:(UIView *)aView {
    CGSize size = aView.frame.size;
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        self.tag = IOS_TAG_IMAGE_VIEW;
        mainView = aView;
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.7f;
        // 添加一个隐藏的按钮
        UIButton *hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [hiddenButton setFrame: CGRectMake(0, 0, size.width, size.height)];
        hiddenButton.backgroundColor = [UIColor clearColor];
        [hiddenButton addTarget:self action:@selector(onImageClick:event:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hiddenButton];
        
        [mainView addSubview:self];
    }
    return self;
}

- (void)loadImage:(UIImage *)image{
    CGSize size = self.frame.size;
    CGFloat max_width = size.width * IMAGE_SCALE;
    CGFloat max_height = size.height * IMAGE_SCALE;
    
    CGSize imgSize = image.size;
    // 图片宽高比例
    CGFloat scale = 0;
    // 确定以高还是宽为主进行缩放
    if ((imgSize.width / imgSize.height) > (max_width / max_height)) {
        // 以宽
        if (max_width < imgSize.width) {
            // 图片宽
            scale = max_width / imgSize.width;
        } else {
            // 图片窄
            scale = 1;
        }
    } else {
        // 以高
        if (max_height < imgSize.height) {
            // 图片高
            scale = max_height / imgSize.height;
        } else {
            scale = 1;
        }
    }
    
    CGFloat w = imgSize.width * scale;
    CGFloat h = imgSize.height * scale;
    
    CGFloat x = (size.width - w) / 2;
    CGFloat y = (size.height - h) / 2;
    
    m_image = image;
    CGRect frame = CGRectMake(x, y, w, h);
    UIImageView *iv = [[UIImageView alloc] initWithImage:m_image];
    iv.frame = frame;
    iv.alpha = 1.0f;
    iv.tag = IOS_TAG_IMAGE_IMAGE;
    [mainView addSubview:iv];
    [iv release];
}

- (id)initWithImage:(UIImage *)image superView:(UIView *)aView {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat max_width = size.width * IMAGE_SCALE;
    CGFloat max_height = size.height * IMAGE_SCALE;
    
    CGSize imgSize = image.size;
    // 图片宽高比例
    CGFloat scale = 0;
    // 确定以高还是宽为主进行缩放
    if ((imgSize.width / imgSize.height) > (max_width / max_height)) {
        // 以宽
        if (max_width < imgSize.width) {
            // 图片宽
            scale = max_width / imgSize.width;
        } else {
            // 图片窄
            scale = 1;
        }
    } else {
        // 以高
        if (max_height < imgSize.height) {
            // 图片高
            scale = max_height / imgSize.height;
        } else {
            scale = 1;
        }
    }
    
    CGFloat w = imgSize.width * scale;
    CGFloat h = imgSize.height * scale;
    
    CGFloat x = (size.width - w) / 2;
    CGFloat y = (size.height - h) / 2;
    
    m_image = image;
    CGRect frame = CGRectMake(x, y/2, w, h);
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        self.tag = IOS_TAG_IMAGE_VIEW;
        mainView = aView;
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.7f;
        UIImageView *iv = [[UIImageView alloc] initWithImage:m_image];
        iv.frame = frame;
        iv.alpha = 1.0f;
        iv.tag = IOS_TAG_IMAGE_IMAGE;
        // 添加一个隐藏的按钮
        UIButton *hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [hiddenButton setFrame: CGRectMake(0, 0, size.width, size.height)];
        hiddenButton.backgroundColor = [UIColor clearColor];
        [hiddenButton addTarget:self action:@selector(onImageClick:event:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hiddenButton];
        
        [mainView addSubview:self];
        [mainView addSubview:iv];
        [iv release];
    }
    return self;
}

- (id)initWithUrl:(NSString *)url superView:(UIView *)aView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self = [self initFromView: aView];
    if (self) {
        httpClient = [HttpDownloader new];
        httpClient.delegate = self;
        [httpClient bufferFromURL:[NSURL URLWithString:url]];
        activity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        CGSize size = self.frame.size;
        activity.frame = CGRectMake(size.width/2, size.height/2, 20.0f, 20.0f);
        [self addSubview:activity];
        [activity startAnimating];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)stopTransfer {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activity stopAnimating];
}

- (BOOL)httpDownloader:(HttpDownloader *)client didError:(BOOL)isError {
    [self stopTransfer];
    return NO;
}

- (BOOL)httpDownloader:(HttpDownloader *)client didFinished:(NSMutableData *)buffer {
    [self stopTransfer];
    UIImage *image = [UIImage imageWithData:buffer];
    [self loadImage:image];
    return NO; 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
