//
//  NSDate+RFC1123.m
//  iOSApi
//
//  Created by WangFeng on 12-1-13.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/NSDate+Utils.h>

@implementation NSDate (Utils)

+ (NSString *)now{
    NSString *sRet = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    sRet = [NSString stringWithString:[dateFormatter stringFromDate:[NSDate date]]];
    [dateFormatter release];
    return sRet;
}

+ (NSDate *)dateFromRFC1123:(NSString *)value_
{
    NSDate *ret = nil;
    NSDateFormatter *_rfc1123 = nil;
    NSDateFormatter *_rfc850 = nil;
    NSDateFormatter *_asctime = nil;
    
    if(value_ == nil){
        return nil;
    }
    
    _rfc1123 = [[NSDateFormatter alloc] init];
    _rfc1123.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
    _rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    _rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    
    ret = [_rfc1123 dateFromString:value_];
    if(ret == nil) {
        _rfc850 = [[NSDateFormatter alloc] init];
        _rfc850.locale = _rfc1123.locale;
        _rfc850.timeZone = _rfc1123.timeZone;
        _rfc850.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
        ret = [_rfc850 dateFromString:value_];
        [_rfc850 release];
        _rfc850 = nil;
    }
    if(ret == nil){
        _asctime = [[NSDateFormatter alloc] init];
        _asctime.locale = _rfc1123.locale;
        _asctime.timeZone = _rfc1123.timeZone;
        _asctime.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
        ret = [_asctime dateFromString:value_];
        [_asctime release];
        _asctime = nil;
    }
    [_rfc1123 release];
    _rfc1123 = nil;
    return ret;
}

- (NSString *)rfc1123String
{
    NSString *sRet = nil;
    NSDateFormatter *_df = [[NSDateFormatter alloc] init];
    _df.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
    _df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //_df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    _df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    sRet = [_df stringFromDate:self];
    [_df release];
    _df = nil;
    return sRet;
}

@end
