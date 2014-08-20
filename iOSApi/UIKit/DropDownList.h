//
//  DropDownList.h
//  iOSApi
//
//  Created by WangFeng on 11-11-1.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownListDelegate;

@interface DropDownList : UITableViewController {
	NSString		          *_searchText;
	NSString		          *_selectedText;
	NSMutableArray	          *_resultList;
	id <DropDownListDelegate>  delegate;
}

@property (nonatomic, copy)   NSString       *_searchText;
@property (nonatomic, copy)   NSString       *_selectedText;
@property (nonatomic, retain) NSMutableArray *_resultList;
@property (assign) id <DropDownListDelegate>  delegate;

- (void)updateData;
- (void)updateData:(NSArray *)list;

@end

@protocol DropDownListDelegate <NSObject>

- (void)passValue:(NSString *)value;

@optional
- (void)dropDown:(DropDownList *)dropDown index:(int)index;

@end
