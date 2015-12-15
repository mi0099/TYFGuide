//
//  TYFSingleObject.h
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/15.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYFSingleObject : NSObject

+(TYFSingleObject *)shareObject;

@property(nonatomic, strong)UINavigationController *nav;

@end
