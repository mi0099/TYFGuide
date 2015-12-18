//
//  TYFAgreementViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/18.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFAgreementViewController.h"

@interface TYFAgreementViewController ()

@end

@implementation TYFAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createWebView];
    [self customItem];
    
}

-(void)createWebView
{
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:Agreement_URL]];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
-(void)customItem
{
    //设置titleView
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"用户协议-佳学";
    label.textColor = TYFColor(241, 67, 118);
    self.navigationItem.titleView = label;
    //设置左按钮
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 24)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"md_back_hui.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)backBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
