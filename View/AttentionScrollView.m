//
//  AttentionScrollView.m
//  NewsFocus
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "AttentionScrollView.h"

#define width self.frame.size.width
#define height self.frame.size.height
@implementation AttentionScrollView {
    HotSpotTableView *_hotSpot;//热点
    SubScribeTableView *_subScribe;//订阅
    NSMutableArray *_dataArray;//热点数组
    //UIButton *_btn;
    NSInteger i;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    i = 1;
    if (self) {
        _dataArray = [NSMutableArray array];
        [self _getHttps:i];
        
        [self _initTable];
        
    }
    
    return self;
}

#pragma mark - 热点界面的数据请求
- (void)_getHttps:(NSInteger)page {
    NSString *httpUrl = hotSpotAddress;//接口地址
    NSString *httpArg = @"channelId=5572a109b3cdc86cf39001db&channelName=%E5%9B%BD%E5%86%85%E6%9C%80%E6%96%B0&page=";//请求参数
    NSString *str = [NSString stringWithFormat:@"%li",page];
    
    httpArg = [httpArg stringByAppendingString:str];
    
    [self request: httpUrl withHttpArg: httpArg];
}


//返回数据并处理
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: apiKey forHTTPHeaderField: @"apikey"];
    
    NSMutableArray *array = [NSMutableArray array];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   //
                                   
                                   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                   //NSLog(@"dic = %@",dic);
                                   
                                   NSDictionary *d1 = dic[@"showapi_res_body"];
                                   NSDictionary *d2 = d1[@"pagebean"];
                                   
                                   for (NSDictionary *d3 in d2[@"contentlist"]) {
                                       HotSpotModel *model = [[HotSpotModel alloc]initWithDic:d3];
                                       [array addObject:model];
                                       
                                   }
                                   if (i == 1) {
                                       _dataArray = array;
                                       _hotSpot.dataArray = _dataArray;
                                       NSLog(@"下拉刷新");
                                   }
                                   else if (i > 1) {
                                       [_dataArray addObjectsFromArray:array];
                                       _hotSpot.dataArray = _dataArray;
                                       
                                       NSLog(@"上拉加载");
                                   }
                                   
                                   [_hotSpot reloadData];
                                   
                                   [_hotSpot.header endRefreshing];
                                   [_hotSpot.footer endRefreshing];
                                   
                               }
                           }];
    
    
    
}

//下拉刷新
- (void)_loadNewData {
    i = 1;
    [self _getHttps:i];
}
//上拉加载
- (void)_loadMoreData {
    i++;
    
    [self _getHttps:i];
    
}

#pragma mark - 两个tableView
- (void)_initTable {
    
    _hotSpot = [[HotSpotTableView alloc]initWithFrame:CGRectMake(0, 0, width, height -49) style:UITableViewStylePlain];
    _subScribe = [[SubScribeTableView alloc]initWithFrame:CGRectMake(width, 0, width, height -49) style:UITableViewStyleGrouped];
//    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btn.frame = CGRectMake(width, 20, width, 60);
//
//    [_btn setTitle:@"+发现更多" forState:UIControlStateNormal];
//    [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    _btn.backgroundColor = [UIColor lightGrayColor];
    
    
    
    _hotSpot.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _hotSpot.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
    [self addSubview:_hotSpot];
    [self addSubview:_subScribe];
    //[self addSubview:_btn];
    
}





@end
