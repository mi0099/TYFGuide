//
//  ZMainTabBarViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/16.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "ZMainTabBarViewController.h"

@interface ZMainTabBarViewController ()

@end

@implementation ZMainTabBarViewController

+(instancetype)shareMainController;
{
    static ZMainTabBarViewController * mainTabBarController=nil;
    static dispatch_once_t tocken;
    dispatch_once(&tocken, ^{
        mainTabBarController=[[ZMainTabBarViewController alloc]init];
    });
    
    return mainTabBarController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
