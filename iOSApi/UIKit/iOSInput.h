//
//  iOSInput.h
//  iOSApi
//
//  Created by WangFeng on 11-12-27.
//  Copyright (c) 2011年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>

typedef enum iOSInputType {
    iOSInputText = 0,
    iOSInputSwitch
}iOSInputType;

/**
 * 动态用户输入对象
 */
@interface iOSInput : NSObject{
    NSString    *name; // 标签名
    id           object; // 变量对象
    iOSInputType type;
    int          tag; // 标签值
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) id object;
@property (nonatomic, assign) iOSInputType type;
@property (nonatomic, assign) int tag;

+ (id)initWithName:(NSString *)name value:(id)value tag:(int)tag type:(iOSInputType)type;

@end
