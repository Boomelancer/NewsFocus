//
//  NewsTableViewCell.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNewsModel:(NewsModel *)newsModel
{
    if (_newsModel != newsModel) {
        
        _newsModel = newsModel;
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    _titlelable.transform = CGAffineTransformIdentity;
//    _descLable.transform = CGAffineTransformIdentity;
    if (_newsModel.NewsimgUrl == nil) {
        
//        _titlelable.transform = CGAffineTransformMakeTranslation(-90, 0);
//        _descLable.transform = CGAffineTransformMakeTranslation(-90, 0);
        _ImageView.image = [UIImage imageNamed:@"aio_pic.png"];
    }
    else
    {
        //图标的 设置
        [_ImageView sd_setImageWithURL:[NSURL URLWithString:_newsModel.NewsimgUrl]];
    }
    //title 设置
    _titlelable.text = _newsModel.NewsTitle;
    _descLable.text = _newsModel.NewsDesc;
    _titlelable.font = [UIFont systemFontOfSize:15];
    _descLable.font = [UIFont systemFontOfSize:13];
    _titlelable.numberOfLines = 0;
    _descLable.numberOfLines = 0;
    _titlelable.textAlignment =NSTextAlignmentLeft;
    _descLable.textAlignment = NSTextAlignmentLeft;
    _descLable.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    
}
@end
