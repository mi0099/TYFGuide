//
//  TYFPassWordViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/18.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFPassWordViewController.h"

@interface TYFPassWordViewController ()<UITextFieldDelegate>

@end

@implementation TYFPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TYFColor(244, 244, 244);
    [self customItem];
    [self createTextField];
    [self createButton];
}

-(void)createButton
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:15];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(textField.frame) + 20, WIDTH - 15 * 2, 40)];
    button.backgroundColor = TYFColor(241, 67, 118);
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.tag = 3;
    [self.view addSubview:button];
}

-(void)createTextField
{
    NSArray *array = @[@"      手机号/邮箱"];
    int i = 0;
    for (NSString *titleName in array) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 64 + 20 + i * (40 + 1), WIDTH - 15 * 2, 40)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.backgroundColor = [UIColor whiteColor];
        textField.placeholder = titleName;
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        [textField resignFirstResponder];
        textField.delegate = self;
        textField.tag = 15 + i;
        [self.view addSubview:textField];
        textField.font = [UIFont systemFontOfSize:15];
        i++;
    }
}


-(void)customItem
{
    //设置titleView
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"找回密码";
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
#pragma mark - UITextFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
