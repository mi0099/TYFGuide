//
//  TYFBoutiqueViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/15.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFBoutiqueViewController.h"
#import "TYFBoutiqueModel.h"
#import "TYFBoutiqueCell.h"
#import "RequestTool.h"
#import "TYFSlideModel.h"
#import "MJRefresh.h"
#import "TYFPushDeatailViewController.h"
//循环广告视图
#import "JCTopic.h"

@interface TYFBoutiqueViewController ()<UITableViewDataSource, UITableViewDelegate, JCTopicDelegate, MJRefreshBaseViewDelegate>
//数据源
@property(nonatomic, strong)NSMutableArray *dataArray;
//循环滚动视图
@property(nonatomic, strong)NSMutableArray *dataArraySlideUrl;
@property(nonatomic, strong)UIPageControl *pageControl;

@property(nonatomic, weak)MJRefreshFooterView *footer;
@property(nonatomic, weak)MJRefreshHeaderView *header;

@end

@implementation TYFBoutiqueViewController
{
    UITableView *_tableView;
    JCTopic *_scrollView;
}
static int a = 20;
static int b = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TYFColor(244, 244, 244);
    _scrollView = [[JCTopic alloc]initWithFrame:CGRectMake(0, 0, WIDTH, (HEIGHT-38)*0.35)];
    _scrollView.JCdelegate = self;
    [self createTableView];
    //设置上啦刷新下啦加载
    [self setupRefreshView];
    //创建广告栏数据
    [self loadSlideData];
}

#pragma mark - 刷新控件
-(void)setupRefreshView
{
    //1.下啦刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    //自动进入刷新状态
    [header beginRefreshing];
    self.header = header;
    //2.上啦加载
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.delegate = self;
}

//释放内存
-(void)dealloc
{
    //释放内存
    [self.header free];
    [self.footer free];
}

#pragma mark - UITableView数据
-(void)loadData
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    //解析数据,存储数据源,做缓存
    NSString *strUrl = [NSString stringWithFormat:BoutiqueURL, a, b];
    [RequestTool requestTitleWithURL:strUrl ListSuccess:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"courses"]) {
            TYFBoutiqueModel *boutiqueModel = [[TYFBoutiqueModel alloc]init];
            [boutiqueModel setValuesForKeysWithDictionary:dict];
            [_dataArray addObject:boutiqueModel];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}
#pragma mark - 循环广告视图数据源
-(void)loadSlideData
{
    if (_dataArraySlideUrl == nil) {
        _dataArraySlideUrl = [[NSMutableArray alloc]init];
    }
    [RequestTool requestTitleWithURL:SlideUrl ListSuccess:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"advs"]) {
            //解析滚动视图的
            TYFSlideModel *sliderModel = [[TYFSlideModel alloc]init];
            [sliderModel setValuesForKeysWithDictionary:dict];
            NSString *priceNum = [NSString stringWithFormat:@"%d", sliderModel.price];
            [_dataArraySlideUrl addObject:[NSDictionary dictionaryWithObjects:@[[sliderModel.iconUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],sliderModel.title,@NO,sliderModel.bgUrl,priceNum,sliderModel._id] forKeys:@[@"pic",@"title",@"isLoc",@"url",@"price",@"_id"]]];
        }
        //加入数据
        _scrollView.pics = _dataArraySlideUrl;
        //更新
        [_scrollView upDate];
        
    } failure:^(NSError *error) {
        //如果解析错误,让刷新控件停止显示刷新状态
        [self.footer endRefreshing];
    }];
}

#pragma mark - 刷新控件进入开始刷新状态的时候调用
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {//上啦加载
        a += 20;
        b += 20;
        [self loadData];
        //让刷新控件停止显示刷新状态
        [self.footer endRefreshing];
    }else{//下啦刷新
        [_dataArray removeAllObjects];
        [self loadData];
        [self.header endRefreshing];
    }
}


#pragma mark - createTableView
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, WIDTH - 20, HEIGHT - 38 - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //取出阴影线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    UIView *viewx = [[UIView alloc]initWithFrame:CGRectMake(0, 35, WIDTH, (HEIGHT - 38) * 0.35)];
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, (HEIGHT - 38) * 0.35 - 25, WIDTH, 20)];
    [viewx addSubview:_scrollView];
    [viewx addSubview:_pageControl];
    _tableView.tableHeaderView = viewx;
    [self.view addSubview:_tableView];
}

#pragma mark - 广告滚动视图的方法
-(void)currentPage:(int)page total:(NSUInteger)total
{
    _pageControl.numberOfPages = total;
    _pageControl.currentPage = page;
}

//循环广告视图的点击事件
-(void)didClick:(NSDictionary *)data
{
    TYFPushDeatailViewController *pushdvc = [[TYFPushDeatailViewController alloc]init];
    pushdvc.titleName = data[@"title"];
    pushdvc.imageViewURL = data[@"pic"];
    pushdvc.priceNum = [data[@"price"] intValue];
    pushdvc._id = data[@"_id"];
    [[TYFSingleObject shareObject].nav pushViewController:pushdvc animated:YES];
}

#pragma mark - UITableView协议方法的实现
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
//每一组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//复用cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYFBoutiqueCell *cell = [TYFBoutiqueCell cellWithTableView:tableView];
    cell.boutiqueModel = _dataArray[indexPath.section];
    return cell;
    
}
//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYFPushDeatailViewController *pushdvc=[[TYFPushDeatailViewController alloc]init];
    TYFBoutiqueModel *model=_dataArray[indexPath.section];
    pushdvc.titleName=model.title;
    pushdvc.imageViewURL=model.bgUrl;
    pushdvc.priceNum=model.price;
    pushdvc._id=model._id;
    [[TYFSingleObject shareObject].nav pushViewController:pushdvc animated:YES];
    //返回的时候被选中cell取消选中状态
    TYFBoutiqueCell *cell = (TYFBoutiqueCell *)[_tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
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
