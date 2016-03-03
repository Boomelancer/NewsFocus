//
//  NewsTableView.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import "NewsTableView.h"
#import "NewsTableViewCell.h"
#import "WebViewController.h"
#import "NewsModel.h"
#import "UIView+UIViewController.h"
@implementation NewsTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self _creatTable];
    }
    return self ;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self _creatTable];
}
-(void)viewDidLoad
{
  
}


-(void)_creatTable
{
    self.delegate = self;
    self.dataSource = self;
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"NewsTableViewCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:@"NewsCell"];
}


-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _NewsDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:nil options:nil];
        cell = [array lastObject];
    }
    //让单元格显示数据
    cell.newsModel = _NewsDataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *vc = [[WebViewController alloc]init];
    NewsModel *model = _NewsDataArray[indexPath.row];
    vc.longUrl = model.NewsDetailLink;
    vc.newsModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}
@end
