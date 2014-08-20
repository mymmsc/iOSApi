#import <UIKit/UIKit.h>

/*--------------------< iOSAsyncImageView class BEGIN >--------------------*/

@interface iOSAsyncImageView : UIView {
	NSURLConnection *connection;
	NSMutableData *data;
	int state;
	NSString *filename;
}

@property (nonatomic, assign) int state;
@property (nonatomic, retain) NSString *filename;

- (void)loadImageFromURL:(NSURL *) url;
- (UIImage *)image;

@end

/*--------------------< iOSAsyncImageView class END >--------------------*/
