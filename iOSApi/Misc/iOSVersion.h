//
//  iOSVersion.h
//  iOSApi
//
//  Created by WangFeng on 11-12-18.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>

/**
 * 版本信息
 */
@interface iOSVersion : NSObject{
    NSString *_author;
	NSString *_verson;
}

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *version;

@end
