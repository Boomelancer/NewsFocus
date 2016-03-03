//
//  HotSpotTableView.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSpotCell.h"
@interface HotSpotTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArray;

@end
