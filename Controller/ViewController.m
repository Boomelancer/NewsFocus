//
//  ViewController.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "ViewController.h"
#import "AttentionScrollView.h"
#import "HotSpotModel.h"
#import "SubInfoModel.h"
#import "Common.h"
#import "SubScribeModel.h"
#import "MJRefresh.h"

#define width self.view.bounds.size.width
#define height self.view.bounds.size.height
@interface ViewController ()<UIScrollViewDelegate>
{
    AttentionScrollView *_scroll;
    NSMutableDictionary *_dataDic;//存储返回的数据
    UIView *_nav;
    NSMutableArray *_subArray;//获取已订阅的数据
    NSInteger num;
    UIView *_view;//顶部视图
    UILabel *_hotLabel;//热点
    UILabel *_subLabel;//订阅
    BOOL isHot;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createViews];
    
    
    NSLog(@"关心页面");
    
    
}

//创建scrollView,以及两个tableView,以及导航栏
- (void)_createViews {
    isHot = YES;
    
    
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 64)];
    _view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    _hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2 - 45, 20, 40, 30)];
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2 + 5, 20, 40, 30)];
    _hotLabel.text = @"热点";
    _subLabel.text = @"订阅";
    _hotLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _hotLabel.textColor = [UIColor blueColor];
    _subLabel.textColor = [UIColor grayColor];
    _hotLabel.layer.cornerRadius = 5;
    _hotLabel.layer.masksToBounds = YES;
    _subLabel.layer.cornerRadius = 5;
    _subLabel.layer.masksToBounds = YES;
    _hotLabel.backgroundColor = [UIColor lightGrayColor];
    [_view addSubview:_hotLabel];
    [_view addSubview:_subLabel];
    
    
    _scroll = [[AttentionScrollView alloc]initWithFrame:CGRectMake(0, 64, width, height-49)];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;

    
    _scroll.contentSize = CGSizeMake(width * 2, 0);
    
    
    [self.view addSubview:_scroll];
    [self.view addSubview:_nav];
    [self.view addSubview:_view];
    
    _scroll.subScribe.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction2)];
    tap1.numberOfTapsRequired = 1;
    tap2.numberOfTapsRequired = 1;
    
    _hotLabel.userInteractionEnabled = YES;
    _subLabel.userInteractionEnabled = YES;
    
    [_hotLabel addGestureRecognizer:tap1];
    [_subLabel addGestureRecognizer:tap2];
}

- (void)tapAction1 {
    isHot = YES;
    [self changeLabel:isHot];
    CGPoint point = CGPointMake(0, -20);
    [UIView animateWithDuration:0.2 animations:^{
        _scroll.contentOffset = point;
    }];
    NSLog(@"hot");
}

- (void)tapAction2 {
    isHot = NO;
    [self changeLabel:isHot];
    CGPoint point = CGPointMake(width, -20);
    [UIView animateWithDuration:0.2 animations:^{
        _scroll.contentOffset = point;
    }];
    NSLog(@"sub");
}

- (void)changeLabel:(BOOL)hot {
    if (hot) {
        _hotLabel.backgroundColor = [UIColor lightGrayColor];
        _hotLabel.textColor = [UIColor blueColor];
        _subLabel.backgroundColor = [UIColor clearColor];
        _subLabel.textColor = [UIColor grayColor];
    }
    else {
        _hotLabel.backgroundColor = [UIColor clearColor];
        _hotLabel.textColor = [UIColor grayColor];
        _subLabel.backgroundColor = [UIColor lightGrayColor];
        _subLabel.textColor = [UIColor blueColor];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self getUserDefaults];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - scrollView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    if (x > width/2) {
        isHot = NO;
    }
    else isHot = YES;
    [self changeLabel:isHot];
}

#pragma mark - 获取本地持久化储存的数据,用于订阅页面,并刷新
- (void)getUserDefaults {
    _subArray = [NSMutableArray array];
    _dataDic = [NSMutableDictionary dictionary];
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"SubInfo"];
    if (array == nil) {
        _subArray = nil;
        _dataDic = nil;
    }
    else {
        for (int j = 0; j<array.count; j++) {
            SubInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:array[j]];
            NSInteger flag = [model.isChosen integerValue];
            if (flag == 1) {
                [_subArray addObject:model];
            }
        }
    }
    NSLog(@"subArray.count = %li",_subArray.count);
    
     _scroll.subScribe.subArray = _subArray;
    if (_subArray.count == 0) {
        [_scroll.subScribe reloadData];
    }
    num = 1;
    [self getHttps:num];
}

//下拉刷新
- (void)_loadNewData {
    num = 1;
    [self getHttps:num];
}


#pragma mark - 数据请求
- (void)getHttps:(NSInteger)page {
    NSString *httpUrl = nil;
    NSString *httpArg = @"num=3&page=";
    NSString *str = [NSString stringWithFormat:@"%li",page];
    httpArg = [httpArg stringByAppendingString:str];
    
    for (int i = 0; i<_subArray.count; i++) {
        SubInfoModel *model = _subArray[i];
        NSInteger flag = [model.isChosen integerValue];
        if (flag == 0) {
            return;
        }
        else {
            if ([model.name isEqualToString:@"苹果新闻"]) {
                httpUrl = appleAddress;
                [self request: httpUrl withHttpArg: httpArg];
            }
            else if ([model.name isEqualToString:@"美女图片"]) {
                httpUrl = girlsAddress;
                [self request: httpUrl withHttpArg: httpArg];
            }
            else if ([model.name isEqualToString:@"科技新闻"]) {
                httpUrl = kejiAddress;
                [self request: httpUrl withHttpArg: httpArg];
            }
            else if ([model.name isEqualToString:@"微信热门精选"]) {
                httpUrl = weChatAddress;
                [self request: httpUrl withHttpArg: httpArg];
            }
        }
    }
}

//NSString *httpUrl = girlsAddress;
//NSString *httpArg = @"num=10&page=";
//NSString *str = [NSString stringWithFormat:@"%li",page];
//httpArg = [httpArg stringByAppendingString:str];
//[self request: httpUrl withHttpArg: httpArg];


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
                                   if ([httpUrl isEqualToString:appleAddress]) {
                                       NSMutableArray *dataArray = [NSMutableArray array];
                                       for (int i = 0; i<3; i++) {
                                           NSString *str = [NSString stringWithFormat:@"%i",i];
                                           SubScribeModel *model = [[SubScribeModel alloc]initWithDic:dic[str]];
                                           [dataArray addObject:model];
                                       }
                                       [_dataDic setObject:dataArray forKey:@"苹果新闻"];
                                   }
                                   else if ([httpUrl isEqualToString:girlsAddress]) {
                                       NSMutableArray *dataArray = [NSMutableArray array];
                                       for (int i = 0; i<3; i++) {
                                           NSString *str = [NSString stringWithFormat:@"%i",i];
                                           SubScribeModel *model = [[SubScribeModel alloc]initWithDic:dic[str]];
                                           [dataArray addObject:model];
                                       }
                                       [_dataDic setObject:dataArray forKey:@"美女图片"];
                                   }
                                   else if ([httpUrl isEqualToString:kejiAddress]) {
                                       NSMutableArray *dataArray = [NSMutableArray array];
                                       for (int i = 0; i<3; i++) {
                                           NSString *str = [NSString stringWithFormat:@"%i",i];
                                           SubScribeModel *model = [[SubScribeModel alloc]initWithDic:dic[str]];
                                           [dataArray addObject:model];
                                       }
                                       [_dataDic setObject:dataArray forKey:@"科技新闻"];
                                   }
                                   else if ([httpUrl isEqualToString:weChatAddress]) {
                                       NSMutableArray *dataArray = [NSMutableArray array];
                                       for (int i = 0; i<3; i++) {
                                           NSString *str = [NSString stringWithFormat:@"%i",i];
                                           SubScribeModel *model = [[SubScribeModel alloc]initWithDic:dic[str]];
                                           [dataArray addObject:model];
                                       }
                                       [_dataDic setObject:dataArray forKey:@"微信热门精选"];
                                   }
                                   
                                   _scroll.subScribe.dataDic = _dataDic;
                                   [_scroll.subScribe reloadData];
                                   [_scroll.subScribe.header endRefreshing];
                                   
                               }
                           }];
}



@end
