//
//  HotSpotTableView.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "HotSpotTableView.h"
#import "WebController.h"
#import "MyUIView+UIViewController.h"
#import "WebViewController.h"
#import "NewsModel.h"
@implementation HotSpotTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initTable];
    }
    return self;
}

- (void)awakeFromNib {
    [self _initTable];
}

- (void)_initTable {
    self.delegate = self;
    self.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"HotSpotCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:@"HotSpotCell"];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotSpotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotSpotCell" forIndexPath:indexPath];
    
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebViewController *web = [[WebViewController alloc]init];
    HotSpotModel *model = _dataArray[indexPath.row];
    
    web.longUrl = model.link;
    web.newsModel.NewsDetailLink= model.link;
    web.newsModel.NewsDesc = @"sflj";
    web.newsModel.NewsimgUrl = model.imageurls;
    web.newsModel.NewsTitle = model.title;
    
    web.hidesBottomBarWhenPushed = YES;
    
    [self.myViewController.navigationController pushViewController:web animated:YES];
    
    NSLog(@"点击");
}

@end
