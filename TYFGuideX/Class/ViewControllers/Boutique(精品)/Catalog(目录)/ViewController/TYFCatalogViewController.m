//
//  TYFCatalogViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/16.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFCatalogViewController.h"
#import "TYFCatalogModel.h"
#import "TYFCatalogCell.h"
#import "RequestTool.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ZSystemPlayerViewController.h"
#import "ZMainTabBarViewController.h"

@interface TYFCatalogViewController ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *dataAllArray;
@property(nonatomic, strong)NSMutableArray *dataTitleArray;
@property(nonatomic, strong)NSMutableDictionary *dataVideoIdArray;

@property(nonatomic, weak) MJRefreshHeaderView *header;

@end

@implementation TYFCatalogViewController
{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TYFColor(244, 244, 244);
    [self createView];
    [self setupRefreshView];
}

#pragma mark - createTableView
-(void)createView
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }if (_dataAllArray == nil) {
        _dataAllArray = [[NSMutableArray alloc]init];
    }if (_dataTitleArray == nil) {
        _dataTitleArray = [[NSMutableArray alloc]init];
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 38 - 64 - 38) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去除阴影线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark - 刷新控件
-(void)setupRefreshView
{
    //1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    //自动进入刷新状态
    [header beginRefreshing];
    self.header = header;
}
-(void)dealloc
{
    //释放内存
    [self.header free];
}

//刷新控件进入开始刷新状态的时候调用
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //下拉刷新
    [_dataAllArray removeAllObjects];
    [_dataArray removeAllObjects];
    [_dataTitleArray removeAllObjects];
    [self loadData];
    [self.header endRefreshing];
}

#pragma mark - 数据源
-(void)loadData
{
    [RequestTool requestTitleWithURL:self.catalogUrl ListSuccess:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"sections"]) {
            for (NSDictionary *dictX in dict[@"lectures"]) {
                TYFCatalogModel *catalogModel = [[TYFCatalogModel alloc]init];
                [catalogModel setValuesForKeysWithDictionary:dictX];
                [_dataArray addObject:catalogModel];
            }
            //加载组数据在总数组中
            [_dataAllArray addObject:_dataArray];
            [_dataTitleArray addObject:@{@"title":dict[@"title"]}];
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - tableView协议方法
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataAllArray.count;
}
//每一组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataAllArray[section] count];
}
//复用cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYFCatalogCell *cell = [TYFCatalogCell cellWithTableView:tableView withNum:indexPath];
    cell.catalogModel = _dataAllArray[indexPath.section][indexPath.row];
    return cell;
}
//设置组名
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _dataTitleArray[section][@"title"];
}
//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataVideoIdArray == nil) {
        _dataVideoIdArray = [[NSMutableDictionary alloc]init];
    }
    TYFCatalogModel *catalogModel = _dataAllArray[indexPath.section][indexPath.row]
    ;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://course.jaxus.cn/api/video/url?type=online&version=1&videoId=%@",catalogModel.videoId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dataVideoIdArray = responseObject[@"url"];
        [self loadingMoiveWith:_dataVideoIdArray[@"quality_10"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    //返回的时候被选中cell取消选中状态
    TYFCatalogCell *cell = (TYFCatalogCell *)[_tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

-(void)loadingMoiveWith:(NSString *)Url
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4", [ZPublic getMd5_32Bit_String:Url isUppercase:NO]]];
    NSLog(@"%@", Url);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ZSystemPlayerViewController *vc;
    if ([fileManager fileExistsAtPath:filePath]) {
        vc=[[ZSystemPlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:filePath]];
    }else{
        vc=[[ZSystemPlayerViewController alloc]initWithContentURL:[NSURL URLWithString:Url]];
    }
    [vc.moviePlayer prepareToPlay];
    [[TYFSingleObject shareObject].nav presentMoviePlayerViewControllerAnimated:vc];
    [vc.moviePlayer play];
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
