//
//  SubScribeCell.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubScribeModel.h"
@interface SubScribeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (nonatomic,strong)SubScribeModel *model;
@end
