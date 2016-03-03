//
//  NewsTableView.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *NewsDataArray;//存储返回的新闻数据

@end
