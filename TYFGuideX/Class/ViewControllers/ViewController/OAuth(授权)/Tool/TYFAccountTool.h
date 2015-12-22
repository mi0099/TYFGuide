//
//  TYFAccountTool.h
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/22.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TYFAccount;
@interface TYFAccountTool : NSObject

//存储账号信息
+(void)saveAccount:(TYFAccount *)account;

//返回存储账号的信息
+(TYFAccount *)account;

@end
