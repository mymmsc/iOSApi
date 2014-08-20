//
//  iOSStar.h
//  iOSApi
//
//  Created by wangfeng on 11-8-5.
//  Copyright 2011年 mymmsc.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iOSStarDelegate;

@interface iOSStar: UIView 
{
    CGFloat   font_size;                // 根据字体大小来确定星星的大小
    NSInteger max_star;                 // 在init里面默认为100
    NSInteger show_star;
    BOOL      isSelect;                 // 是否支持选择星数
    
    UIColor  *empty_color;
    UIColor  *full_color;
}
@property (nonatomic, assign) id/*<iOSTableDataDelegate>*/ delegate;
@property (nonatomic, assign) CGFloat   font_size;
@property (nonatomic, assign) NSInteger max_star;
@property (nonatomic, assign) NSInteger show_star;
@property (nonatomic, retain) UIColor  *empty_color;
@property (nonatomic, retain) UIColor  *full_color;
@property (nonatomic, assign) BOOL      isSelect; 

@end

@protocol iOSStarDelegate <NSObject>

@optional
- (void)star:(iOSStar *)star onChange:(int)value;

@end