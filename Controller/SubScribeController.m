//
//  SubScribeController.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/28.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "SubScribeController.h"
#import "SubInfoModel.h"
@interface SubScribeController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_table;
    NSMutableDictionary *_addressDic;
    NSMutableArray *_dataArray;
}

@end

@implementation SubScribeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createTable];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title = @"订阅管理";
    
}

- (void)_createTable {
    
    _addressDic = [NSMutableDictionary dictionary];
    _dataArray = [NSMutableArray array];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"SubInfo"];//获取本地持久化存储的订阅信息
    if (array == nil) {
        NSArray *name = @[@"苹果新闻",@"科技新闻",@"微信热门精选",@"美女图片"];
        NSArray *iconName = @[@"apple.png",@"keji.png",@"weChat.png",@"girls.png"];
        NSArray *address = @[@"http://apis.baidu.com/txapi/apple/apple",
                             @"http://apis.baidu.com/txapi/keji/keji",
                             @"http://apis.baidu.com/txapi/weixin/wxhot",
                             @"http://apis.baidu.com/txapi/mvtp/meinv"];
        NSArray *isChosen = @[@0,@0,@0,@0];
        for (int i = 0;  i < 4; i++) {
            SubInfoModel *model = [[SubInfoModel alloc]init];
            model.name = name[i];
            model.iconName = iconName[i];
            model.address = address[i];
            model.isChosen = isChosen[i];
            
            [_dataArray addObject:model];
            
            NSLog(@"dataArray:%@",_dataArray);
        }
        
        NSLog(@"array是空的：%@",array);
        
    }
    else {
//        _dataArray = (NSMutableArray *)array;
//        NSLog(@"array不是空的:%@",array);
        for (int i = 0; i<array.count; i++) {
            SubInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:array[i]];
            [_dataArray addObject:model];
        }
    }
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    
    _table.delegate = self;
    _table.dataSource = self;
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    SubInfoModel *model = _dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *view = [self _createViewWithImage:model.iconName name:model.name isChosen:model.isChosen tag:indexPath.row + 100];
    
    NSLog(@"model.name:%@",model.name);
    
    [cell.contentView addSubview:view];
    
    return cell;
}

#pragma mark - 创建cell上的视图
- (UIView *)_createViewWithImage:(NSString *)iconName
                            name:(NSString *)name
                        isChosen:(NSNumber *)isChosen
                             tag:(NSInteger)tag {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 60)];
    imageV.image = [UIImage imageNamed:iconName];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 15, 120, 50)];
    label.text = name;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(250, 15, 100, 50)];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeButtonType:button isChosen:isChosen];
    
    [view addSubview:imageV];
    [view addSubview:label];
    [view addSubview:button];
    
    return view;
}

#pragma mark - 按钮处理
//改变按钮的状态:订阅?取消订阅
- (void)changeButtonType:(UIButton *)button isChosen:(NSNumber *)isChosen {
    NSInteger flag = [isChosen integerValue];
    BOOL chosen = NO;
    
    if (flag == 0) {
        chosen = NO;
    }
    else if (flag == 1){
        chosen = YES;
    }
    
    if (chosen) {
        //[button setBackgroundImage:[UIImage imageNamed:@"right.jpg"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:@"取消订阅" forState:UIControlStateNormal];
        NSLog(@"取消订阅");
    }
    else if (!chosen) {
        //[button setBackgroundImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
        [button setTitle:@"+订阅" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        NSLog(@"订阅");
    }
}
//按钮行为
- (void)buttonAction:(UIButton *)button {
    if (button.tag == 100) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:100];
        SubInfoModel *model = _dataArray[0];
        model.isChosen = [self changeBOOL:model.isChosen];
        [self changeButtonType:btn isChosen:model.isChosen];
        _dataArray[0] = model;
        
        NSLog(@"改变状态0");
        
    }
    else if (button.tag == 101) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:101];
        SubInfoModel *model = _dataArray[1];
        model.isChosen = [self changeBOOL:model.isChosen];
        [self changeButtonType:btn isChosen:model.isChosen];
        _dataArray[1] = model;
        NSLog(@"改变状态1");
    }
    else if (button.tag == 102) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:102];
        SubInfoModel *model = _dataArray[2];
        model.isChosen = [self changeBOOL:model.isChosen];
        [self changeButtonType:btn isChosen:model.isChosen];
        _dataArray[2] = model;
        
        NSLog(@"改变状态2");
    }
    else if (button.tag == 103) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:103];
        SubInfoModel *model = _dataArray[3];
        model.isChosen = [self changeBOOL:model.isChosen];
        [self changeButtonType:btn isChosen:model.isChosen];
        _dataArray[3] = model;
        
        NSLog(@"改变状态3");
    }
}

//在离开本界面前改变本地持久化存储的内容
- (void)viewWillDisappear:(BOOL)animated {
    [self changerUserDefaults];
}

//改变本地持久化存储的内容
- (void)changerUserDefaults {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i<_dataArray.count; i++) {
        SubInfoModel *model = _dataArray[i];
        //将model里面的数据转换为data类型才能存储
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [dataArray addObject:data];
    }
    NSArray *array = [NSArray arrayWithArray:dataArray];
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"SubInfo"];
}

- (NSNumber *)changeBOOL:(NSNumber *)isChosen {
    NSInteger flag = [isChosen integerValue];
    if (flag == 1) {
        flag = 0;
    }
    else flag = 1;
    
    NSNumber *chosen = [NSNumber numberWithInteger:flag];
    return chosen;
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
