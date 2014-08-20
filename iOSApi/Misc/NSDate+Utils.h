//
//  NSDate+RFC1123.h
//  iOSApi
//
//  Created by  on 12-1-13.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>

@interface NSDate (Utils)

+ (NSString *)now;

/**
 Convert a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1)
 into NSDate.
 */
+ (NSDate *)dateFromRFC1123:(NSString*)value_;

/**
 Convert NSDate into a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1).
 */
- (NSString *)rfc1123String;

@end
