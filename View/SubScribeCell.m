//
//  SubScribeCell.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "SubScribeCell.h"
#import "UIImageView+WebCache.h"
@implementation SubScribeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    //[self layoutSubviews];
    _title.text = _model.title;
    NSURL *url = [NSURL URLWithString:_model.picUrl];
    [_icon sd_setImageWithURL:url];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
