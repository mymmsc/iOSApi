//
//  NSArray+Utils.m
//  iOSApi
//
//  Created by wangfeng on 12-3-10.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "NSArray+Utils.h"
#import "NSDictionary+Utils.h"

@implementation NSArray (Utils)

- (NSMutableArray *)toList:(Class)clazz{
    NSMutableArray *list = nil;
    for (NSObject *item in self) {
        if ([item isKindOfClass:NSDictionary.class]) {
            NSDictionary *obj = (NSDictionary *)item;
            if (obj == nil || obj.count == 0) {
                continue;
            } else if(list == nil){
                list = [[NSMutableArray alloc] initWithCapacity:0];
            }
            id value = [obj toObject:clazz];
            [list addObject:value];
        }
    }
    return [list autorelease];
}

@end
