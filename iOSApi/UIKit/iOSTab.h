//
//  iOSTab.h
//  iOSApi
//
//  Created by WangFeng on 11-12-16.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi+UIKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface iOSTab : UIButton {
	UIImage *background;
	UIImage *rightBorder;
}

- (id)initWithIconImageName:(NSString *)imageName;

@end
