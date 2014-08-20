//
//  iOSUnknown.m
//  iOSApi
//
//  Created by wangfeng on 12-4-2.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "iOSUnknown.h"

@implementation iOSUnknown

static NSMutableDictionary *_hashMap = nil;

+ (void)init{
    if (_hashMap == nil) {
        _hashMap = [[NSMutableDictionary alloc] init];
    }
    
}

- (void)dealloc{
    IOSAPI_RELEASE(_hashMap);
    [super dealloc];
}

+ (id)get:(id)key{
    @synchronized(self) {
        [self init];
        id value = [_hashMap objectForKey:key];
        return value;
    }
}

+ (void)set:(id)key value:(id)value{
    @synchronized(self) {
        [self init];
        [_hashMap setObject:value forKey:key];
    }
}

+ (void)remove:(id)key{
    @synchronized(self) {
        [self init];
        [_hashMap removeObjectForKey:key];
    }
}

@end
