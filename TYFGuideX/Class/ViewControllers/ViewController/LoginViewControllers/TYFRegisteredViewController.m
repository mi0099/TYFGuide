//
//  TYFRegisteredViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/18.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFRegisteredViewController.h"
#import "TYFAgreementViewController.h"

@interface TYFRegisteredViewController ()<UITextFieldDelegate>

@end

@implementation TYFRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = TYFColor(244, 244, 244);
    [self customItem];
    [self createTextField];
    [self createButton];
    [self createLabel];
    
}

#pragma mark - 创建控件
-(void)customItem
{
    //设置titleView
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"注册";
    label.textColor = TYFColor(241, 67, 118);
    self.navigationItem.titleView = label;
    //设置左按钮
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 24)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"md_back_hui.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];

}


-(void)createTextField
{
    NSArray *array = @[@"      手机/邮箱", @"      密码(6 - 32位字母,数字或符号)"];
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
        textField.tag = 10 + 1 + i;
        textField.font = [UIFont systemFontOfSize:15];
        i++;
    }
}
-(void)createButton
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:12];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(textField.frame) + 20, WIDTH - 15 * 2, 40)];
    button.backgroundColor = TYFColor(241, 67, 118);
    [button setTitle:@"注册" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.tag = 13;
    [self.view addSubview:button];
}

-(void)createLabel
{
    UIButton *button = (UIButton *)[self.view viewWithTag:13];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(button.frame) + 5, WIDTH / 2 , 20)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize: 12];
    label.text = @"点击\"注册\",则表示您已经同意";
    [self.view addSubview:label];
    UIButton *agreementButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMaxY(button.frame) + 5, WIDTH / 2 - 45, 20)];
    [agreementButton setTitleColor:TYFColor(241, 67, 118) forState:UIControlStateNormal];
    [agreementButton setTitle:@"《佳学用户协议》" forState:UIControlStateNormal];
    agreementButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [agreementButton addTarget:self action:@selector(pushAgreementButtonViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementButton];
}

-(void)pushAgreementButtonViewController:(UIButton *)button
{
    TYFAgreementViewController *avc = [[TYFAgreementViewController alloc]init];
    [self.navigationController pushViewController:avc animated:YES];
}

-(void)backBtn
{
    //返回上一级视图
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag - 10) {
        case 1:
        {
            UITextField *textField = (UITextField *)[self.view viewWithTag:12];
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
