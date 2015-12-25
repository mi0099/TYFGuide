//
//  TYFRootViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/15.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFRootViewController.h"
#import "MenuViewController.h"
#import "TYFClassifyViewController.h"
#import "TYFRankingViewController.h"
#import "TYFBoutiqueViewController.h"
#import "TYFLoginViewController.h"
#import "ScannerViewController.h"

@interface TYFRootViewController ()

@property(nonatomic, strong)MenuViewController *menuVC;

@end

@implementation TYFRootViewController

//在即将实现到屏幕上时,记录一下导航控制器
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [TYFSingleObject shareObject].nav = self.navigationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self customItem];
    [self createControllers];
}

-(void)createControllers
{
    //分类
    TYFClassifyViewController *cvc = [[TYFClassifyViewController alloc]init];
    //精品
    TYFBoutiqueViewController *bvc = [[TYFBoutiqueViewController alloc]init];
    //排行
    TYFRankingViewController *rvc = [[TYFRankingViewController alloc]init];
    _menuVC = [[MenuViewController alloc]initViewControllerWithTitleArray:@[@"分类", @"精品", @"排行"] vcArray:@[cvc, bvc, rvc] Frame:0];
    _menuVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:_menuVC.view];

}

-(void)customItem
{
    //设置镂空色
    self.navigationController.navigationBar.tintColor = TYFColor(241, 67, 118);
    self.navigationController.navigationBar.translucent = NO;
    //设置titleView
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"发现课程";
    label.textColor = TYFColor(241, 67, 118);
    self.navigationItem.titleView = label;
    //设置右按钮
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchController)];
    self.navigationItem.rightBarButtonItem = searchItem;
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 18)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"ic_drawer.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)backBtn
{
    //通过模态视图推出登录界面
    TYFLoginViewController *loginVc = [[TYFLoginViewController alloc]init];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:loginVc];
    [self presentViewController:nc animated:YES completion:^{
        NSLog(@"视图推出完毕");
    }];
}

//查找页面
-(void)searchController
{
    ScannerViewController *svc = [[ScannerViewController alloc]init];
    [self presentViewController:svc animated:YES completion:nil];
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
