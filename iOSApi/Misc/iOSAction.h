//
//  iOSAction.h
//  iOSApi
//
//  Created by WangFeng on 11-12-27.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi+UIKit.h>

@interface iOSAction : NSObject {
    NSString *_action;
    NSString *_icon;
    NSString *_title;
    NSString *_comment;
    NSString *_nib;
    NSString *_type;
}

@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *nib;
@property (nonatomic, copy) NSString *type;

+ (id)initWithName:(NSString *)name class:(NSString *)clazz;

- (id)newInstance;

@end
