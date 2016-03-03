//
//  HotSpotCell.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "HotSpotCell.h"
#import "UIImageView+WebCache.h"
@implementation HotSpotCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _title.text = _model.title;
    _source.text = _model.source;
    NSURL *url = [NSURL URLWithString:_model.imageurls];
    
    [_image sd_setImageWithURL:url];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
