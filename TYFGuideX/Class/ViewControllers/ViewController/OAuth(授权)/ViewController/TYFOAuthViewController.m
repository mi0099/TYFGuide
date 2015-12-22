//
//  TYFOAuthViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/22.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFOAuthViewController.h"
#import "AFNetworking.h"
#import "TYFAccount.h"
#import "TYFAccountTool.h"
#import "MBProgressHUD+MJ.h"

@interface TYFOAuthViewController ()<UIWebViewDelegate>

@end

@implementation TYFOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.添加webView
    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    //2.加载授权页面(新浪提供的登录页面)
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=4230180649&redirect_uri=http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - webView代理方法
//webView开始发送请求的时候就会调用
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //显示提醒框
    [MBProgressHUD showMessage:@"加载中..."];
}
//webView请求完毕的时候会调用
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //隐藏提醒框
    [MBProgressHUD hideHUD];
}
/*
    webView请求完毕的时候会调用
 */
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏提醒框
    [MBProgressHUD hideHUD];
}
//当webView发送一个请求之前都会先调用这个方法,询问代理可不可以加载这个页面(请求)
//return YES 可以加载页面 NO 不可以加载页面
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //1.请求URL路径
    NSString *urlStr = request.URL.absoluteString;
    //2.查找code在urlStr中得范围
    NSRange range = [urlStr rangeOfString:@"code="];
    //3.如果urlStr中包含了code=
//    if (range.location != NSNotFound)
    if (range.length) {
        //4.截取code=后面的请求标记(经过用户授权成功的)
        int loc = range.location + range.length;
        NSString *code = [urlStr substringFromIndex:loc];
        //5.发送POST请求给新浪,通过code换取一个accessToken
        [self accessTokenWithCode:code];
        //不加载这个请求
        return NO;
    }
    return YES;
}

//通过code换取一个accessToken redirect_uritrue string回调地址,需要与注册的回调地址一致
-(void)accessTokenWithCode:(NSString *)code
{
    //AFNetworting/AFN
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"4230180649";
    params[@"client_secret"]=@"7fbbcaf70504dfe27c90794f5aa8ed24";
    params[@"grant_type"]=@"authorization_code";
    params[@"code"]=code;
    params[@"redirect_uri"]=@"http://www.baidu.com";
    //3.发送请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //4.先将字典转为模型
        TYFAccount *account = [TYFAccount accountWithDict:responseObject];
        //5.存储模型数据
        [TYFAccountTool saveAccount:account];
        //6.隐藏提醒框
        [MBProgressHUD hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败: %@", error);
        //隐藏提醒框
        [MBProgressHUD hideHUD];
    }];
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
