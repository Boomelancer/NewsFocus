//
//  NewsTableViewCell.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "HYActivityView.h"
@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelable;
@property (weak, nonatomic) IBOutlet UILabel *descLable;
@property(nonatomic,strong)NewsModel *newsModel;

@end
