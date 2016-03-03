//
//  MoreViewController.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/28.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *iconName;
@property (nonatomic,strong)NSString *url;

@end
