//
//  TYFClassifyViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/15.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFClassifyViewController.h"
#import "TYFDetailsViewController.h"
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

-(void)dealloc
{
    //释放内存
    [self.header free];
}

//刷新控件进入开始刷新状态的时候调用
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {//上拉刷新
        
    }else{//下拉刷新
        [_dataArray removeAllObjects];
        [self loadData];
        //让刷新控件停止显示刷新状态
        [self.header endRefreshing];
    }
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

#pragma mark - tableView协议方法
//每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//复用cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYFClassityCell *cell = [TYFClassityCell cellWithTableView:tableView];
    cell.classityModel = _dataArray[indexPath.row];
    return cell;
}
//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYFDetailsViewController *vc=[[TYFDetailsViewController alloc]init];
    TYFClassityModel *classityModel=_dataArray[indexPath.row];
    vc.url=[NSString stringWithFormat:@"%@%@%@",@"http://course.jaxus.cn/api/category/",classityModel._id,@"/courses?channel=appstore&end=%d&freeCourse=0&platform=2&start=%d"];
    vc.titleName=classityModel.name;
    [[TYFSingleObject shareObject].nav pushViewController:vc animated:YES];
    //返回的时候被选中cell取消选中状态
    TYFClassityCell *cell=(TYFClassityCell *)[_tableView cellForRowAtIndexPath:indexPath];
    cell.selected=NO;
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
