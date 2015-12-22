//
//  TYFLoginViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/17.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFLoginViewController.h"
#import "TYFRegisteredViewController.h"
#import "TYFPassWordViewController.h"

@interface TYFLoginViewController ()<UITextFieldDelegate>

@end

@implementation TYFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TYFColor(244, 244, 244);
    [self customItem];
    //创建登录界面
    [self createTextField];
    //创建登录按钮
    [self createButton];
    //创建注册按钮
    [self createRegisteredButton];
    //创建第三方登录按钮
    [self createThirdLoginButton];
}

#pragma mark - 创建控件
-(void)createThirdLoginButton
{
    NSArray *array = @[@"login_qq.png", @"wx_logo.png", @"login_weibo.png"];
    int i = 0;
    for (NSString *imageName in array) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH * 0.2) * (i + 1) + 10, HEIGHT * 0.7, WIDTH * 0.15 - 10, WIDTH * 0.15 - 10)];
//        button.backgroundColor = [UIColor redColor];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self.view addSubview:button];
        i++;
        button.tag = 30 + i;
        [button addTarget:self action:@selector(thirdLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//第三方登录
-(void)thirdLoginClick:(UIButton *)button
{
    switch (button.tag - 30) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}

-(void)customItem
{
    //设置titleView
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"登录";
    label.textColor = TYFColor(241, 67, 118);
    self.navigationItem.titleView = label;
    //设置左按钮
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 18)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:TYFColor(241, 67, 118) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
}
-(void)createTextField
{
    NSArray *array = @[@"      手机/邮箱", @"      密码"];
    int i = 0;
    for (NSString *titleName in array) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 64 + 20 + i * (40 + 1), WIDTH - 15 * 2, 40)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.backgroundColor = [UIColor whiteColor];
        textField.placeholder = titleName;
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        if (i == 1) {
            //密文显示
            textField.secureTextEntry = YES;
        }
        textField.delegate = self;
        [self.view addSubview:textField];
        textField.tag = 1 + i;
        textField.font = [UIFont systemFontOfSize:15];
         i++;
    }
}
-(void)createButton
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:2];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(textField.frame) + 20, WIDTH - 15 * 2, 40)];
    button.backgroundColor = TYFColor(241, 67, 118);
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.tag = 3;
    [self.view addSubview:button];
}
-(void)createRegisteredButton
{
    UIButton *loginButton = (UIButton *)[self.view viewWithTag:3];
    UIButton *registeredButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 15 - 55, CGRectGetMaxY(loginButton.frame) + 10, 55, 20)];
    [registeredButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [registeredButton setTitleColor:TYFColor(241, 67, 118) forState:UIControlStateNormal];
    //添加事件
    [registeredButton addTarget:self action:@selector(registeredOnClick:) forControlEvents:UIControlEventTouchUpInside];
    registeredButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:registeredButton];
    //忘记密码
    UIButton *passwordButton = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(loginButton.frame) + 10, 55, 20)];
    [passwordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [passwordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [passwordButton addTarget:self action:@selector(passwordOnClick:) forControlEvents:UIControlEventTouchUpInside];
    passwordButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:passwordButton];
}

-(void)registeredOnClick:(UIButton *)button
{
    //推出注册页面
    TYFRegisteredViewController *svc = [[TYFRegisteredViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)passwordOnClick:(UIButton *)button
{
    //推出找回密码页面
    TYFPassWordViewController *pvc = [[TYFPassWordViewController alloc]init];
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void)backViewController
{
    //移除模态视图
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"移除模态视图控制器");
    }];
}

#pragma mark - UITextFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            UITextField *textField = (UITextField *)[self.view viewWithTag:2];
            [textField becomeFirstResponder];
        }
            break;
        case 2:
        {
            [textField resignFirstResponder];
        }
        default:
            break;
    }
    return YES;
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
