//
//  TYFPushSingleObject.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/16.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFPushSingleObject.h"

@implementation TYFPushSingleObject

+(TYFPushSingleObject *)shareObject
{
    static TYFPushSingleObject *sinObj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sinObj=[[TYFPushSingleObject alloc]init];
    });
    return sinObj;
}

@end
