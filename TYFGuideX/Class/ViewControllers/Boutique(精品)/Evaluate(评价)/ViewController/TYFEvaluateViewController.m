//
//  TYFEvaluateViewController.m
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/16.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import "TYFEvaluateViewController.h"
#import "TYFEvaluateFrame.h"
#import "TYFEvaluateModel.h"
#import "TYFEvaluateCell.h"
#import "RequestTool.h"
#import "MJRefresh.h"

@interface TYFEvaluateViewController ()<UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSNumber *commentNum;
@property(nonatomic, weak)MJRefreshHeaderView *header;

@end

@implementation TYFEvaluateViewController
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
#pragma mark - 数据源
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

#pragma mark - createTableView
-(void)createTableView
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 38 - 38) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
#pragma mark - 数据源
-(void)loadData
{
    [RequestTool requestTitleWithURL:self.evaluateUrl ListSuccess:^(id responseObject) {
        self.commentNum = responseObject[@"commentNum"];
        for (NSDictionary *dict in responseObject[@"comments"]) {
            TYFEvaluateModel *evaluateModel = [[TYFEvaluateModel alloc]init];
            [evaluateModel setValuesForKeysWithDictionary:dict];
            //frame模型
            TYFEvaluateFrame *evaluateFrame = [[TYFEvaluateFrame alloc]init];
            evaluateFrame.evaluateModel = evaluateModel;
            [_dataArray addObject:evaluateFrame];
        }
        [_tableView reloadData];
        //定制tableView头
        [self coutomsTableViewHeader];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

-(void)coutomsTableViewHeader
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 33)];
    _tableView.tableHeaderView = view;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 65, 23)];
    [imageView setImage:[UIImage imageNamed:@"StarsForeground"]];
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+3, 5, 50, 23)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:@"(%d)",[self.commentNum intValue]];
    [view addSubview:label];
    UILabel *evaluationLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-100, 5, 100, 23)];
    evaluationLabel.textColor=[UIColor grayColor];
    evaluationLabel.font=[UIFont systemFontOfSize:13];
    evaluationLabel.text=@"参与后可评价";
    [view addSubview:evaluationLabel];
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
    TYFEvaluateCell *cell = [TYFEvaluateCell cellWithTableView:tableView];
    //给cell传递模型
    cell.evaluateFrame = _dataArray[indexPath.row];
    return cell;
}
//返回cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYFEvaluateFrame *evaluateFrame = _dataArray[indexPath.row];
    return evaluateFrame.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回的时候被选中cell取消选中状态
    TYFEvaluateCell *cell = (TYFEvaluateCell *)[_tableView cellForRowAtIndexPath:indexPath];
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
