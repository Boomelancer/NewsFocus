//
//  AttentionScrollView.h
//  NewsFocus
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSpotTableView.h"
#import "SubScribeTableView.h"
#import "HotSpotModel.h"
#import "MJRefresh.h"
#import "Common.h"
#import "SubInfoModel.h"
@interface AttentionScrollView : UIScrollView
//HotSpotTableView *_hotSpot;//热点
//SubScribeTableView *_subScribe;//订阅
//NSMutableArray *_dataArray;//热点数组

@property (nonatomic,strong)HotSpotTableView *hotSpot;//热点
@property (nonatomic,strong)SubScribeTableView *subScribe;//订阅
@property (nonatomic,strong)NSMutableArray *dataArray;//热点数组
@property (nonatomic,strong)NSMutableArray *subArray;//订阅
@end
