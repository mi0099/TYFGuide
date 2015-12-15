//
//  TYFRankingViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/15.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFRankingViewController.h"
#import "RequestTool.h"
#import "TYFBoutiqueCell.h"
#import "TYFBoutiqueModel.h"
#import "MJRefresh.h"
#import "TYFPushDeatailViewController.h"

@interface TYFRankingViewController ()<UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, weak) MJRefreshFooterView *footer;
@property (nonatomic, weak) MJRefreshHeaderView *header;

@end

@implementation TYFRankingViewController
{
    UITableView *_tableView;
}
static int a=20;
static int b=0;
static int k=1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TYFColor(244, 244, 244);
    [self createTableView];
    //刷新控件
    [self setupRefreshView];
}

#pragma mark - setupRefreshView
-(void)setupRefreshView
{
    //1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    //自动进入刷新状态
    [header beginRefreshing];
    self.header = header;
    //2.上拉加载(上拉加载更多数据)
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.delegate = self;
    self.footer = footer;
}
-(void)dealloc
{
    //释放
    [self.footer free];
    [self.header free];
}
//刷新控件进入开始刷新状态的时候调用
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {//上拉加载
        a += 20;
        b += 20;
        [self loadData];
        //让刷新控件停止显示刷新状态
        [self.footer endRefreshing];
    }else{//下拉刷新
        k = 1;
        [_dataArray removeAllObjects];
        [self loadData];
        [self.header endRefreshing];
    }
}

-(void)loadData
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    NSString *strUrl = [NSString stringWithFormat:RankingURL, a, b];
    [RequestTool requestTitleWithURL:strUrl ListSuccess:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"courses"]) {
            TYFBoutiqueModel *model = [[TYFBoutiqueModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            model.title = [NSString stringWithFormat:@"%d. %@", k++, model.title];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - createTableView
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, WIDTH - 20, HEIGHT - 38 - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去除阴影线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark - tableView协议方法的实现
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
//点击对应的cell以后
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYFPushDeatailViewController *pushVc = [[TYFPushDeatailViewController alloc]init];
    TYFBoutiqueModel *model = _dataArray[indexPath.section];
    pushVc.titleName = model.title;
    pushVc.imageViewURL = model.bgUrl;
    pushVc.priceNum = model.price;
    pushVc._id = model._id;
    [[TYFSingleObject shareObject].nav pushViewController:pushVc animated:YES];
    //返回时被选中cell取消选中状态
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
