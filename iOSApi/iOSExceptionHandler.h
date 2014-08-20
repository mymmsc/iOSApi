//
//  iOSExceptionHandler.h
//  iOSApi
//
//  Created by wangfeng on 12-5-19.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>
//====================================< 异常捕捉 - 接口 >====================================

@interface iOSExceptionHandler : NSObject{
    
}

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*)getHandler;

@end
