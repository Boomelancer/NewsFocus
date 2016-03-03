//
//  SubScribeTableView.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "SubScribeTableView.h"
#import "SubScribeCell.h"
#import "SubScribeController.h"
#import "MyUIView+UIViewController.h"
#import "SubInfoModel.h"
#import "WebController.h"
#import "MoreViewController.h"
#import "WebViewController.h"
@implementation SubScribeTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initTable];
    }
    return self;
}

-(void)awakeFromNib {
    [self _initTable];
}

- (void)_initTable {
    self.delegate = self;
    self.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"SubScribeCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:@"SubScribeCell"];
}


#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _subArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    }
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"+发现更多";
        cell.textLabel.textColor = [UIColor colorWithRed:93/255 green:164/255 blue:202/255 alpha:1];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    SubScribeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubScribeCell" forIndexPath:indexPath];
    SubInfoModel *infoModel = _subArray[indexPath.section - 1];
    NSArray *array = _dataDic[infoModel.name];
    SubScribeModel *scribeModel = array[indexPath.row];
    
    cell.model = scribeModel;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        SubInfoModel *model = [[SubInfoModel alloc]init];
        model = _subArray[section - 1];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 30)];
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 100, 20)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 35, 5, 30, 30)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        imageV.image = [UIImage imageNamed:model.iconName];
        name.text = model.name;
        name.font = [UIFont systemFontOfSize:14];
        label.text = @">";
        label.font = [UIFont systemFontOfSize:30];
        name.textColor = [UIColor blackColor];
        label.textColor = [UIColor blueColor];
        [button addSubview:imageV];
        [button addSubview:name];
        [button addSubview:label];
        
        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = 100 + section;
        
        return button;
    }
    return nil;
}
//点击头视图
- (void)buttonAction:(UIButton *)button {
    SubInfoModel *infoModel = _subArray[button.tag - 101];

    MoreViewController *mvc = [[MoreViewController alloc]init];
    
    mvc.name = infoModel.name;
    mvc.iconName = infoModel.iconName;
    mvc.url = infoModel.address;
    [self.myViewController.navigationController pushViewController:mvc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SubScribeController *ssc = [[SubScribeController alloc]init];
        ssc.hidesBottomBarWhenPushed = YES;
        [self.myViewController.navigationController pushViewController:ssc animated:YES];
    }
    else {
        SubInfoModel *infoModel = _subArray[indexPath.section - 1];
        NSArray *array = _dataDic[infoModel.name];
        SubScribeModel *scribeModel = array[indexPath.row];
        WebViewController *web = [[WebViewController alloc]init];
        web.longUrl = scribeModel.url;
        web.hidesBottomBarWhenPushed = YES;
        [self.myViewController.navigationController pushViewController:web animated:YES];
        
    }
    
    NSLog(@"点击");
}




@end
