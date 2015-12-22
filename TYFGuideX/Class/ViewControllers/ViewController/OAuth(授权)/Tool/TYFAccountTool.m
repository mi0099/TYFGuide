//
//  TYFAccountTool.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/22.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFAccountTool.h"
#import "TYFAccount.h"

#define TYFAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation TYFAccountTool

+(void)saveAccount:(TYFAccount *)account
{
    //计算账号的过期时间
    NSDate *now = [NSDate date];
    account.expriesTime = [now dateByAddingTimeInterval:account.expires_in];
    [NSKeyedArchiver archiveRootObject:account toFile:TYFAccountFile];
}

+(TYFAccount *)account
{
    //取出账号
    TYFAccount *accout = [NSKeyedUnarchiver unarchiveObjectWithFile:TYFAccountFile];
    //判断账号是否过期
    NSDate *now = [NSDate date];
    if ([now compare:accout.expriesTime] == NSOrderedAscending) {
        //还没过期
        return accout;
    }else{
        //过期
        return nil;
    }
}

@end
