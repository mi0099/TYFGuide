//
//  TYFPushDeatailsViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/16.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFPushDeatailsViewController.h"
#import "TYFDetailsCell.h"
#import "TYFDetailsFrame.h"
#import "TYFDetailsModel.h"
#import "MJRefresh.h"
#import "RequestTool.h"
#import "TYFDetailsContentView.h"
#import "UIImageView+WebCache.h"

@interface TYFPushDeatailsViewController ()<UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, weak)MJRefreshHeaderView *header;

@end

@implementation TYFPushDeatailsViewController
{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TYFColor(244, 244, 244);
    [self createTableView];
    [self setupRefreshView];
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
/**
 *  刷新控件进入开始刷新状态的时候调用
 */
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //下拉刷新
    [_dataArray removeAllObjects];
    [self loadData];
    [self.header endRefreshing];
}

#pragma mark - 数据源
-(void)loadData
{
    [RequestTool requestTitleWithURL:self.detailsUrl ListSuccess:^(id responseObject) {
        TYFDetailsModel *detailsModel = [[TYFDetailsModel alloc]init];
        [detailsModel setValuesForKeysWithDictionary:responseObject];
        //frame模型
        TYFDetailsFrame *detailsFrame = [[TYFDetailsFrame alloc]init];
        detailsFrame.detailsModel = detailsModel;
        [_dataArray addObject:detailsFrame];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - createTableView
-(void)createTableView
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-38-38) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去除阴影线
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    view.backgroundColor = [UIColor whiteColor];
    TYFDetailsContentView *contentView = [TYFDetailsContentView contentView];
    contentView.collectionUrl = self.detailsUrl;
    [view addSubview:contentView];
    _tableView.tableFooterView = view;
}

#pragma mark - 协议方法
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//复用cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    TYFDetailsCell *cell = [TYFDetailsCell cellWithTableView:tableView];
    //给cell传递模型
    cell.detailsFrame = _dataArray[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, (HEIGHT-38)*0.35-20)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[cell.detailsFrame.detailsModel.bgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    tableView.tableHeaderView=imageView;
    return cell;
}
//返回cell的高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYFDetailsFrame *detailsFrame = _dataArray[indexPath.row];
    return detailsFrame.cellHeight;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回的时候被选中cell取消选中状态
    TYFDetailsCell *cell = (TYFDetailsCell *)[_tableView cellForRowAtIndexPath:indexPath];
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
