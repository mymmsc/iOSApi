#import "iOSAsyncImageView.h"
#import <iOSApi/iOSApi.h>
/*--------------------< iSOAsyncImageView class BEGIN >--------------------*/

@implementation iOSAsyncImageView

@synthesize state, filename;

#define ISO_CACHE_PATH @"cache"

static NSString *path = nil;

- (void)reload:(UIImage *)image {
	UIImageView *imageView = [[[UIImageView alloc] initWithImage: image] autorelease];
	/*
	 imageView.contentMode = UIViewContentModeScaleAspectFit;
	 imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight);
	 */
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[self.superview bringSubviewToFront:self];
	[imageView setNeedsLayout];
	[self setNeedsLayout];
	state = 10;	
}

- (void)loadImageFromURL:(NSURL *)url {
	NSFileManager *fm = [NSFileManager defaultManager];
	filename = [[NSString alloc] initWithFormat: @"%@.jpg", [iOSApi md5: [url path]]];
	NSString *filepath = [NSString stringWithFormat: @"%@/%@", path, filename];
	//NSLog(@"FileName is <%@>.", filepath);
	if ([fm fileExistsAtPath: filepath]) {
		//UIImage *image = [iSOApi imageNamed: filepath];
		UIImage* image = [UIImage imageWithContentsOfFile:filepath];
		[self reload: image];
		return;
	}
	if (connection != nil) {
		[connection release];
	}
	if (data != nil) {
		[data release];
	}
	state = -1;
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	//NSLog(@"loading image....");
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data == nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
	}
	state = 1;
	[data appendData:incrementalData];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)theConnection {
	[connection release];
	connection = nil;
	if ([[self subviews] count] >0) {
		[[[self subviews] objectAtIndex:0] removeFromSuperview];
	}
	if ([data length] > 1024) {
		//NSLog(@"path is <%@>.", path);
		//NSLog(@"filename is <%@>.", filename);
		NSString *fpath = [path stringByAppendingPathComponent: filename];
		//NSLog(@"FileName is <%@>.", fpath);
		[data writeToFile:fpath atomically:YES];
	}
		//NSFileManager *fm = [NSFileManager defaultManager];
		//[fm createFileAtPath: filename contents: data attributes: nil];
	[self reload: [UIImage imageWithData:data]];
	[data retain];
	[data release];
	data = nil;
}

- (UIImage *)image {
	UIImageView *iv = [[self subviews] objectAtIndex:0];
	// 拉伸
	[iv setContentStretch:[self frame]];
	return [iv image];
}

- (id)initWithFrame:(CGRect)frame {
    state = -1;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		if (path == nil) {
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
																 NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			path = [[NSString alloc] initWithFormat: @"%@/%@", documentsDirectory, ISO_CACHE_PATH];
			//NSLog(@"FileName is <%@>.", path);
			NSFileManager *fm = [NSFileManager defaultManager];
			BOOL isDir = YES;
			if(![fm fileExistsAtPath: path isDirectory: &isDir]){
				[iOSApi mkdirs: path];
			}
		}
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}

@end

/*--------------------< iOSAsyncImageView class END >--------------------*/

