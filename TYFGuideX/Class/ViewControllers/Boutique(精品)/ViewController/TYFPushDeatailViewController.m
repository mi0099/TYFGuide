//
//  TYFPushDeatailViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/15.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFPushDeatailViewController.h"
#import "MenuViewController.h"
#import "TYFCatalogViewController.h"
#import "TYFEvaluateViewController.h"
#import "TYFPushDeatailsViewController.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>

@interface TYFPushDeatailViewController ()

@property(nonatomic, strong)MenuViewController *menuVCX;

@end

@implementation TYFPushDeatailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self customItem];
    [self createControllers];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [TYFPushSingleObject shareObject].nav = self.navigationController;
}

-(void)customItem
{
    //设置镂空色
    self.navigationController.navigationBar.tintColor = TYFColor(241, 67, 118);
    //设置titleView
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.titleName;
    label.textColor = TYFColor(241, 67, 118);
    self.navigationItem.titleView = label;
    //设置右按钮
    //设置右按钮
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionController)];
    self.navigationItem.rightBarButtonItem=searchItem;
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 24)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"md_back_hui.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//查找页面
-(void)actionController
{
   //社会化组件分享
    NSString *imagePath=[[NSBundle mainBundle]pathForResource:@"me4s" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"IMBA刀塔助手"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"#IMBA刀塔助手#"
                                                  url:@"http://www.dota2.com.cn/"
                                          description:@"IMBA刀塔助手是一款你值得拥有的！ ~~"
                                            mediaType:SSPublishContentMediaTypeNews];
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
                          [NSNumber numberWithInteger:ShareTypeWeixiSession],
                          [NSNumber numberWithInteger:ShareTypeSinaWeibo],
                          [NSNumber numberWithInteger:ShareTypeQQ],
                          [NSNumber numberWithInteger:ShareTypeQQSpace],[NSNumber numberWithInteger:ShareTypeDouBan],[NSNumber numberWithInteger:ShareTypeInstagram],[NSNumber numberWithInteger:ShareTypeEvernote],nil];
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    

}

//创建视图控制器
-(void)createControllers
{
    //详情
    TYFPushDeatailsViewController *pdvc = [[TYFPushDeatailsViewController alloc]init];
    //详情URL
    NSString *detailsUrl = [NSString stringWithFormat:@"http://course.jaxus.cn/api/course/%@",self._id];
    pdvc.detailsUrl = detailsUrl;
    //目录
    TYFCatalogViewController *cvc = [[TYFCatalogViewController alloc]init];
    //目录URL
    NSString *catalogUrl = [NSString stringWithFormat:@"http://course.jaxus.cn/api/course/%@/sections",self._id];
    cvc.catalogUrl = catalogUrl;
    //评价
    TYFEvaluateViewController *evc = [[TYFEvaluateViewController alloc]init];
    //评价URL
    NSString *evaluateUrl =[NSString stringWithFormat:@"http://course.jaxus.cn/api/course/%@/comment?end=20&start=0",self._id];
    evc.evaluateUrl = evaluateUrl;
#pragma mark - 创建详情,目录,评价页面
    _menuVCX = [[MenuViewController alloc]initViewControllerWithTitleArray:@[@"详情", @"目录", @"评价"] vcArray:@[pdvc, cvc, evc] Frame:0];
    [self.view addSubview:_menuVCX.view];
    //下方课程的按钮
    UIButton *joinButton = [[UIButton alloc]initWithFrame:CGRectMake(0, HEIGHT-102, WIDTH, 38)];
    [joinButton addTarget:self action:@selector(joinButtonClick) forControlEvents:UIControlEventTouchUpInside];
    joinButton.backgroundColor = TYFColor(241, 67, 118);
    [self.view addSubview:joinButton];
    UILabel *joinLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH*0.7, 38)];
    joinLabel.text = @"参加该课程";
    joinLabel.textColor = [UIColor whiteColor];
    joinLabel.font = [UIFont systemFontOfSize:16];
    [joinButton addSubview:joinLabel];
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.8, 0, WIDTH*0.2, 38)];
    priceLabel.textColor = [UIColor whiteColor];
    [joinButton addSubview:priceLabel];
}

-(void)joinButtonClick
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"登录功能正在开发，敬请期待" message:@"点击继续" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alter show];
    
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
