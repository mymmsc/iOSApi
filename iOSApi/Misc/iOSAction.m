//
//  iOSAction.m
//  iOSApi
//
//  Created by WangFeng on 11-12-27.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSAction.h>

@implementation iOSAction

@synthesize action = _action;
@synthesize icon = _icon;
@synthesize title = _title;
@synthesize comment = _comment;
@synthesize nib = _nib;
@synthesize type = _type;

- (void)dealloc{
    [_icon release];
    [_title release];
    [_comment release];
    [_action release];
    [_nib release];
    [_type release];
    [super dealloc];
}

+ (id)initWithName:(NSString *)name class:(NSString *)clazz {
    iOSAction *obj = [iOSAction new];
	[obj setTitle:name];
	[obj setAction:clazz];
	
	return [obj autorelease];
}

- (id)newInstance{
    id obj = nil;
    if (_nib != nil) {
        obj = [iOSApi objectFrom:_action nib:_nib];
    } else {
        obj = [iOSApi objectFrom:_action];
    }
    return [obj retain];
}

@end
