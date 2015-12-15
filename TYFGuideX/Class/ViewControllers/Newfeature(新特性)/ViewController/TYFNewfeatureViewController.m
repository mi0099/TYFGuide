//
//  TYFNewfeatureViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/14.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFNewfeatureViewController.h"
//当前页面需要几张导航页
#define TYFNewfeatureImageCount 3

@interface TYFNewfeatureViewController ()

//设置pageControl
@property(nonatomic, weak)UIPageControl *pageControl;

@end

@implementation TYFNewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.添加UIScrollView
    [self setupScrollView];
    
}

#pragma mark - 添加ScrollView
-(void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    //2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (NSInteger index = 0; index < TYFNewfeatureImageCount; index++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        //设置图片
        NSString *name = [NSString stringWithFormat:@"new"];
        imageView.image = [UIImage imageNamed:name];
        //设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        [scrollView addSubview:imageView];
        UIImageView *imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(imageX+(WIDTH-200)/2, HEIGHT*0.2, 200, 200)];
        imageHead.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_image%ld.png", (long)index + 1]];
        [scrollView addSubview:imageHead];
        UIImageView *imageViewTitle = [[UIImageView alloc]initWithFrame:CGRectMake(imageX+(WIDTH-260)/2, CGRectGetMaxY(imageHead.frame)+10, 260,72)];
        imageViewTitle.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_title%ld.png",index+1]];
        [scrollView addSubview:imageViewTitle];
        imageViewTitle.userInteractionEnabled = YES;
        //在最后一个图片上添加按钮
        if (index == TYFNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    //设置滚动内容的尺寸
    scrollView.contentSize = CGSizeMake(imageW * TYFNewfeatureImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    
    
    
    
}

//将内容添加到最后一个图片上
-(void)setupLastImageView:(UIImageView *)imageView
{
    //0.imageView默认是不可点击的 将其设置为能和用户进行交互的
    imageView.userInteractionEnabled = YES;
    //1.添加开始按钮
    UIButton *startButton = [[UIButton alloc]init];
    [startButton setBackgroundImage:[UIImage imageNamed:@"guide4_go_pressed.png"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"guide4_go.png"] forState:UIControlStateHighlighted];
    //2.设置frame
    CGFloat centerX = imageView.frame.size.width
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
