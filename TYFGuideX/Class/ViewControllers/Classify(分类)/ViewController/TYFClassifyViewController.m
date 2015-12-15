//
//  TYFClassifyViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/15.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFClassifyViewController.h"
#import "RequestTool.h"
#import "TYFClassityCell.h"
#import "TYFClassityModel.h"
#import "MJRefresh.h"

@interface TYFClassifyViewController ()<UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, weak) MJRefreshHeaderView *header;

@end

@implementation TYFClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TYFColor(244, 244, 244);
    //1.集成刷新控件
    [self createTableView];
    [self setupRefreshView];
}

#pragma mark - 下拉刷新
-(void)setupRefreshView
{
    //1.下啦刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    //自动进入刷新状态
    [header beginRefreshing];
    self.header = header;
}

#pragma mark - 创建数据源
-(void)loadData
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    [RequestTool requestTitleWithURL:ClassitfyURL ListSuccess:^(id responseObject) {
        for (NSDictionary *dict  in responseObject[@"subcategories"]) {
            TYFClassityModel *classityModel = [[TYFClassityModel alloc]init];
            [classityModel setValuesForKeysWithDictionary:dict];
            [_dataArray addObject:classityModel];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - 创建TableView
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 38) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //取出阴影线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
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
