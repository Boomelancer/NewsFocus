//
//  HotSpotCell.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSpotModel.h"

@interface HotSpotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (nonatomic,strong)HotSpotModel *model;


@end
