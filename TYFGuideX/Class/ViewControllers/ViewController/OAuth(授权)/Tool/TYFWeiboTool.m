//
//  TYFWeiboTool.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/22.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFWeiboTool.h"
#import "TYFNewfeatureViewController.h"
#import "TYFRootViewController.h"

@implementation TYFWeiboTool

+(void)chooseRootController
{
    NSString *key=@"CFBundleVersion";
    //取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *lastVersion=[defaults stringForKey:key];
    //获取当前软件版本号
    NSString *currentVersion=[NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        //显示状态栏
        [UIApplication sharedApplication].statusBarHidden=NO;
        [UIApplication sharedApplication].keyWindow.rootViewController=[[TYFRootViewController alloc]init];
        
    }else{
        //新版本
        [UIApplication sharedApplication].keyWindow.rootViewController=[[TYFNewfeatureViewController alloc]init];
        //存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }

}

@end
