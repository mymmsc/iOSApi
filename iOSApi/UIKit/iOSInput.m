//
//  iOSInput.m
//  iOSApi
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSInput.h>

@implementation iOSInput

@synthesize name, object, tag, type;

- (void)dealloc {
    [name release];
    [object release];
    
    [super dealloc];
}

+ (id)initWithName:(NSString *)name value:(id)value tag:(int)tag type:(iOSInputType)type {
    iOSInput *obj = [[iOSInput alloc] init];
    obj.name = name;
    obj.object = value;
    obj.type = type;
    obj.tag = tag;
    return [obj autorelease];
}

@end
