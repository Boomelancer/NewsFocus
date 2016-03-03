//
//  SubScribeModel.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "SubScribeModel.h"

@implementation SubScribeModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _title = dic[@"title"];
        _url = dic[@"url"];
        _picUrl = dic[@"picUrl"];
    }
    return self;
}



@end
