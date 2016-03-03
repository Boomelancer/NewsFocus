//
//  MoreViewController.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/28.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "MoreViewController.h"
#import "SubScribeCell.h"
#import "Common.h"
#import "WebController.h"
#import "MJRefresh.h"
@interface MoreViewController ()

@end

@implementation MoreViewController {
    UITableView *_table;
    NSMutableArray *_dataArray;
    NSInteger num;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createViews];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
}
#pragma mark - 创建视图
- (void)_createViews {
    num = 1;

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.textColor = [UIColor blackColor];
    label.text = _name;

    self.navigationItem.titleView = label;
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
    
    _table.delegate = self;
    _table.dataSource = self;
    
    _dataArray = [NSMutableArray array];
    
    UINib *nib = [UINib nibWithNibName:@"SubScribeCell" bundle:nil];
    [_table registerNib:nib forCellReuseIdentifier:@"SubScribeCell"];
    
    [self _getHttps:1];
    
    _table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
}

#pragma 网络请求
- (void)_getHttps:(NSInteger)page {
    NSString *httpUrl = _url;
    NSString *httpArg = @"num=10&page=";
    NSString *str = [NSString stringWithFormat:@"%li",page];
    httpArg = [httpArg stringByAppendingString:str];
    
    [self request:httpUrl withHttpArg:httpArg];
}

//下拉刷新
- (void)_loadNewData {
    num = 1;
    [self _getHttps:num];
}
//上拉加载
- (void)_loadMoreData {
    num++;
    [self _getHttps:num];
}

#pragma mark - 返回数据的处理
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: apiKey forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                   //根据地址判断是哪一个api
                                   if ([_name isEqualToString:@"苹果新闻"]) {
                                       NSArray *array = dic[@"newslist"];
                                       for (NSDictionary *d in array) {
                                           SubScribeModel *model = [[SubScribeModel alloc]initWithDic:d];
                                           [_dataArray addObject:model];
                                       }
                                   }
                                   else {
                                       for (int i = 0; i < 10; i++) {
                                           NSString *str = [NSString stringWithFormat:@"%i",i];
                                           SubScribeModel *model = [[SubScribeModel alloc]initWithDic:dic[str]];
                                           [_dataArray addObject:model];
                                       }
                                   }
                                   [_table reloadData];
                                   [_table.header endRefreshing];
                                   [_table.footer endRefreshing];
                                   
                               }
                           }];
}


#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubScribeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubScribeCell" forIndexPath:indexPath];
    
    SubScribeModel *model = _dataArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.view.bounds.size.width/2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/2 - 10)];
    imageV.image = [UIImage imageNamed:_iconName];
    return imageV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubScribeModel *model = _dataArray[indexPath.row];
    WebController *web = [[WebController alloc]init];
    
    web.link = model.url;
    
    [self.navigationController pushViewController:web animated:YES];
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
