//
//  TYFPushSingleObject.h
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/16.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYFPushSingleObject : NSObject

+(TYFPushSingleObject *)shareObject;

@property(nonatomic, strong) UINavigationController *nav;

@end
