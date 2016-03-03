//
//  ChannelModel.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import "ChannelModel.h"

@implementation ChannelModel
-(id)initWitdDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        _channedid = dic[@"channelId"];
        _channelName = [dic[@"name"] substringToIndex:2];
    }
    return self;
}
@end
