//
//  SubScribeTableView.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubScribeTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSArray *subArray;//订阅数

@property (nonatomic,strong) NSDictionary *dataDic;

@end
