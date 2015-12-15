//
//  TYFSingleObject.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/15.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFSingleObject.h"

@implementation TYFSingleObject

+(TYFSingleObject *)shareObject
{
    static TYFSingleObject *singleObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleObject = [[TYFSingleObject alloc]init];
    });
    return singleObject;
}

@end
