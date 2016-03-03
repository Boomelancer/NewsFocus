//
//  MainAppViewController.m
//  helloworld
//
//  Created by chen on 14/7/13.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "MainAppViewController.h"
#import "SliderViewController.h"
#import "NewsTableView.h"
#import "AFNetworking.h"
#import "ChannelModel.h"
#import "NewsModel.h"
#import "NewsTableView.h"
#import "WebViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import <TencentOpenAPI/sdkdef.h>
#define MENU_HEIGHT 25
#define MENU_BUTTON_WIDTH  61

@interface MainAppViewController ()<UIScrollViewDelegate>
{
    UIView *_navView;//导航栏
    UIView *_topNaviV;//频道选择
    UIScrollView *_scrollV;//显示各个频道的新闻 视图
    
    UIScrollView *_navScrollV;//频道滚动
    UIView *_navBgV;//选择频道 下划线
    
    float _startPointX;
    UIView *_selectTabV;//点击加号之后创建的视图
    
    ChannelModel *model;
    NSMutableArray *dataArray;
    MBProgressHUD *HUD;
}

@end

@implementation MainAppViewController
{
    NSInteger pageID;
    NewsTableView *_tableView;
    NewsModel *model1;
    UIButton *rbtn;
}

-(void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    _ChanelldArray = [NSMutableArray array];//存储频道
    dataArray = [[NSMutableArray alloc]init];//存储新闻数据
    
    
    [self getchannelJsonData];
    //创建视图
    [self _creatView];
    //创建＋号视图和频道
    [self createTwo];
    //默认如果频道为nil 就是设置为首页的那个界面的新闻
    ChannelModel *temM = _ChanelldArray[pageID];
    [self getChannelNewsInfor:temM.channedid pullrefresh:NO];
    
    //添加观测者 当QQ登陆成功之后改变头像视图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage:) name:kTencentUserInfor object:nil];
}

//
-(void)changeImage:(NSNotification *)notification
{
    APIResponse *response = notification.userInfo[kTencentUserInfor];
    NSDictionary *dic = response.jsonResponse;
    
    NSURL *url = [NSURL URLWithString:dic[@"figureurl_qq_2"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:data];
    
    [rbtn setImage:image forState:UIControlStateNormal];
    
    //头像
   // [ sd_setImageWithURL:dic[@"figureurl_qq_2"]];
}


#pragma mark - 数据获取
//获取频道 并将数据写入json文件 为了避免程序执行重复写入 故在此只执行该函数一次
-(void)ChannelNetWorkRequest
{
    [MyNetWorkRequest NetWorkRequest:SelectChannelSearch ChannelID:nil completionHandle:^(id result) {
    
        //为json文件拼接路径
        NSString *Json_path= [self filePath];
         //==写入文件 如果没有该文件则先会创建文件
         NSLog(@"%@",[result writeToFile:Json_path atomically:YES] ? @"Succeed":@"Failed");

    } errorHandle:^(NSError *error) {
        
    }];
}

//获取json文件路径
-(NSString *)filePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    //为json文件拼接路径
    NSString *Json_path=[path stringByAppendingPathComponent:@"JsonFile.json"];
    return Json_path;
}


//在本地获取频道相关的 json数据
-(void)getchannelJsonData
{

    NSString *Json_path= [[NSBundle mainBundle] pathForResource:@"JsonFile" ofType:@"json"];

    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:Json_path];
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *dic2 = dic1[@"showapi_res_body"];
    NSArray *array = dic2[@"channelList"];
    
    for (NSDictionary *dic in array) {
        if ([dic[@"name"] length] == 4) {
            ChannelModel *model = [[ChannelModel alloc]initWitdDic:dic];
            [_ChanelldArray addObject:model];
        }
    }
}

//根据频道的id 获取新闻
-(void)getChannelNewsInfor:(NSString *)channelId pullrefresh:(BOOL)p
{
    [self HUDShowProgress:@"正在加载"];
    [MyNetWorkRequest NetWorkRequest:SelectNewsSearch ChannelID:channelId completionHandle:^(id result) {
        [self completeHUD];
        [self receiveNewsDataCompleteHandle:result pullRefresh:p];
    } errorHandle:^(NSError *error) {
        NSLog(@"失败");
    }];
}

//新闻数据接收完成之后 执行该方法
-(void)receiveNewsDataCompleteHandle:(id)newsInfor pullRefresh:(BOOL)p
{
    //数据解析
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:newsInfor options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *dic1 = [jsonDic objectForKey:@"showapi_res_body"];
    NSDictionary *dic2 = dic1[@"pagebean"];
    NSArray *array = dic2[@"contentlist"];

    _NewsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        model1 = [[NewsModel alloc]initWithDic:dic];
        [_NewsArray addObject:model1];
    }

    //首页
    NewsTableView *view = (NewsTableView *)[_scrollV viewWithTag:pageID + 1];
    view.NewsDataArray = _NewsArray;
    [view reloadData];
    [view.header endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - 视图创建
//创建导航栏、状态栏
-(void)_creatView
{
    self.view.backgroundColor = [UIColor whiteColor];
    //状态栏
    
//    UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
//    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)
//    {
//        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.f);
//        statusBarView.backgroundColor = [UIColor clearColor];
//        ((UIImageView *)statusBarView).backgroundColor = RGBA(255,5,13,1);
//        [self.view addSubview:statusBarView];
//    }
    //导航栏
    _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, StatusbarSize, self.view.frame.size.width, 44.f)];
    ((UIImageView *)_navView).backgroundColor = RGBA(236,236,236,1);
    //[self.view insertSubview:_navView belowSubview:statusBarView];
    [self.view addSubview:_navView];
    _navView.userInteractionEnabled = YES;
    
    //导航栏中间的title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, (_navView.frame.size.height - 40)/2, 200, 40)];
    [titleLabel setText:@"新闻列表"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    //导航栏上左边的按钮
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lbtn setFrame:CGRectMake(10, 2, 40, 40)];
    //[lbtn setTitle:@"频道" forState:UIControlStateNormal];
    [lbtn setImage:[UIImage imageNamed:@"miniPlistLlick.tiff"] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:lbtn];
    
    //导航栏上右边的按钮
    rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setFrame:CGRectMake(_navView.frame.size.width - 36 - 15, _navView.frame.size.height/2 - 18, 36, 36)];
    rbtn.layer.cornerRadius = 18;
    rbtn.layer.masksToBounds = YES;
    rbtn.layer.borderColor = [UIColor yellowColor].CGColor;
    rbtn.layer.borderWidth = 2;

    //[rbtn setTitle:@"个人" forState:UIControlStateNormal];
    [rbtn setImage:[UIImage imageNamed:@"head1.jpg"] forState:UIControlStateNormal];
    
    [rbtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:rbtn];
    
    //频道选择
    _topNaviV = [[UIView alloc] initWithFrame:CGRectMake(0, _navView.frame.size.height + _navView.frame.origin.y, self.view.frame.size.width, MENU_HEIGHT)];
    //[_topNaviV setBackgroundColor:[UIColor greenColor]];
    _topNaviV.backgroundColor = RGBA(236.f, 236.f, 236.f, 1);
    [self.view addSubview:_topNaviV];
    
    //显示各个频道的新闻
    _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topNaviV.frame.origin.y + _topNaviV.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topNaviV.frame.origin.y - _topNaviV.frame.size.height-49)];
    [_scrollV setPagingEnabled:YES];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    [self.view insertSubview:_scrollV belowSubview:_navView];
    _scrollV.delegate = self;
    [_scrollV.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    
    //点击加号之后创建的视图 先隐藏
    _selectTabV = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollV.frame.origin.y - _scrollV.frame.size.height, _scrollV.frame.size.width, _scrollV.frame.size.height)];
    [_selectTabV setBackgroundColor:RGBA(236.f, 236.f, 236.f, 1)];
    [_selectTabV setHidden:YES];
    [self.view insertSubview:_selectTabV belowSubview:_navView];
}

//红色按钮 和频道
- (void)createTwo
{
//    float btnW = 30; //+ 按钮宽度
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(_topNaviV.frame.size.width - btnW, 1, btnW - 2, MENU_HEIGHT - 2)];
//    [btn setBackgroundColor:[UIColor clearColor]];
//    //[btn setTitle:@"+" forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"home_newfolder_hl.tiff"] forState:UIControlStateNormal];
//    [_topNaviV addSubview:btn];
//    [btn addTarget:self action:@selector(showSelectView:) forControlEvents:UIControlEventTouchUpInside];
    
    //频道创建
    NSArray *arT = _ChanelldArray;
    
    _navScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, MENU_HEIGHT)];
    [_navScrollV setShowsHorizontalScrollIndicator:NO];
    for (int i = 0; i < [arT count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH * i, 0, MENU_BUTTON_WIDTH, MENU_HEIGHT)];

        ChannelModel *temModel = [arT objectAtIndex:i];
        [btn setTitle:temModel.channelName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_navScrollV addSubview:btn];
    }
    [_navScrollV setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * [arT count], MENU_HEIGHT)];
    [_topNaviV addSubview:_navScrollV];
    
    //选择状态 频道的下滑线
    _navBgV = [[UIView alloc] initWithFrame:CGRectMake(0, MENU_HEIGHT - 2, MENU_BUTTON_WIDTH, 2)];
    [_navBgV setBackgroundColor:[UIColor redColor]];
    [_navScrollV addSubview:_navBgV];
    
    [self addView2Page:_scrollV count:[arT count] frame:CGRectZero];
}

#pragma mark - 导航栏下面部分
//创建显示各个新闻页的滚动视图的 滚动范围
- (void)addView2Page:(UIScrollView *)scrollV count:(NSUInteger)pageCount frame:(CGRect)frame
{
    for (int i = 0; i < pageCount; i++)
    {
        _tableView = [[NewsTableView alloc]initWithFrame:CGRectMake(scrollV.frame.size.width * i, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
        _tableView.tag = i + 1;
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshData)];
//        _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_moreData)];

        [scrollV addSubview:_tableView];
    }
    //设置滚动视图的大小
    [scrollV setContentSize:CGSizeMake(scrollV.frame.size.width * pageCount, scrollV.frame.size.height)];
}

//下拉刷新
-(void)_refreshData
{
    ChannelModel *model2 = _ChanelldArray[pageID];
    [self getChannelNewsInfor:model2.channedid pullrefresh:YES];
}


//视图滚动结束之后调用 效果是让红色下划线视图跟着移动
- (void)changeView:(float)x
{
    float xx = x * (MENU_BUTTON_WIDTH / self.view.frame.size.width);
    //滑动视图之后 在此添加网络请求新闻数据
    
    if (pageID != (NSInteger)x/375) {
        
        pageID = x/375.0;//获取对应频道的编号
        //NSLog(@"pageId = %ld",(long)pageID);
        model = _ChanelldArray[pageID];
        [self getChannelNewsInfor:model.channedid pullrefresh:NO];
    }
    [_navBgV setFrame:CGRectMake(xx, _navBgV.frame.origin.y, _navBgV.frame.size.width, _navBgV.frame.size.height)];
}


#pragma mark - 进度视图
//正在加载
-(void)HUDShowProgress:(NSString *)title
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    [HUD show:YES];
    HUD.dimBackground = YES;//有个遮罩层的作用 不能点击
}

-(void)hideHUD
{
    
    [HUD hide:YES];
}

//加载完成之后
-(void)completeHUD
{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"加载完成";
    [HUD hide:YES afterDelay:2];
}

#pragma mark - action

//频道切换
- (void)actionbtn:(UIButton *)btn
{
    [_scrollV scrollRectToVisible:CGRectMake(_scrollV.frame.size.width * (btn.tag - 1), _scrollV.frame.origin.y, _scrollV.frame.size.width, _scrollV.frame.size.height) animated:YES];
    //点击频道之后 在此添加网络请求新闻数据
    float xx = _scrollV.frame.size.width * (btn.tag - 1) * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
    [_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
}

//导航栏上的左边的按钮
- (void)leftAction:(UIButton *)btn
{
    if ([_selectTabV isHidden] == NO)
    {
        [self showSelectView:btn];
        return;
    }
    [((SliderViewController *)[[[self.view superview] superview] nextResponder]) showLeftViewController];
}

//导航栏上的右边的按钮
- (void)rightAction:(UIButton *)btn
{
    if ([_selectTabV isHidden] == NO)
    {
        [self showSelectView:btn];
        return;
    }
    //找到sliderViewController
    [((SliderViewController *)[[[self.view superview] superview] nextResponder]) showRightViewController];
}

//加号 的响应方法
- (void)showSelectView:(UIButton *)btn
{
    if ([_selectTabV isHidden] == YES)
    {
        [_selectTabV setHidden:NO];
        [UIView animateWithDuration:0.6 animations:^
         {
             [_selectTabV setFrame:CGRectMake(0, _scrollV.frame.origin.y, _scrollV.frame.size.width, _scrollV.frame.size.height)];
         } completion:^(BOOL finished)
         {
         }];
    }else
    {
        [UIView animateWithDuration:0.6 animations:^
         {
             [_selectTabV setFrame:CGRectMake(0, _scrollV.frame.origin.y - _scrollV.frame.size.height, _scrollV.frame.size.width, _scrollV.frame.size.height)];
         } completion:^(BOOL finished)
         {
             [_selectTabV setHidden:YES];
         }];
    }
}

//新闻页的左右滑动处理
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    BOOL isPaning = NO;
    //左边滑动
    if(_scrollV.contentOffset.x < 0)
    {
        isPaning = YES;
//        isLeftDragging = YES;
//        [self showMask];
    }//右边滑动
    else if(_scrollV.contentOffset.x > (_scrollV.contentSize.width - _scrollV.frame.size.width))
    {
        isPaning = YES;
        // isRightDragging = YES;
            //[self showMask];
    }
    if(isPaning)
    {//根据手势移动视图
        [((SliderViewController *)[[[self.view superview] superview] nextResponder]) moveViewWithGesture:panParam];
    }
}



//- (void)pust2View:(NSNotification *)notification
//{
//  
//    WebViewController *vc = [[WebViewController alloc]init];
//    NewsModel *model = notification.object;
//    vc.longUrl = model.NewsDetailLink;
//    
//    [[QHMainGestureRecognizerViewController getMainGRViewCtrl] addViewController2Main:vc];
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _startPointX = scrollView.contentOffset.x;
}

//点击频道按钮或者滑动都会执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeView:scrollView.contentOffset.x];
}
//滚动视图减速结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
    [_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
}

@end
