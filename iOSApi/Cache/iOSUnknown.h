//
//  iOSUnknown.h
//  iOSApi
//
//  Created by wangfeng on 12-4-2.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>
//====================================< UnKnown >====================================
// 拟为 扩展类 增加对象 托管机制
@interface iOSUnknown : NSObject{
    //
}

+ (id)get:(id)key;
+ (void)set:(id)key value:(id)value;
+ (void)remove:(id)key;

@end
