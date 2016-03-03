//
//  MainAppViewController.h
//  helloworld
//
//  Created by chen on 14/7/13.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainAppViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *ChanelldArray;//频道
@property(nonatomic,strong)NSMutableArray *NewsArray;//新闻
@property(nonatomic,strong)NSMutableArray *allChannelNewsArrays;
@end
