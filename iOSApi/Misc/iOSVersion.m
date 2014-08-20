//
//  iOSVersion.m
//  iOSApi
//
//  Created by WangFeng on 11-12-18.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSVersion.h>

@implementation iOSVersion

@synthesize author = _author, version = _verson;

- (void)dealloc{
    [_author release];
    [_verson release];
    
    [super dealloc];
}

@end
