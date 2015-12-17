//
//  TYFLoginViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/17.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFLoginViewController.h"

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
}

#pragma mark - 创建控件
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
    [self.view addSubview:button];
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
