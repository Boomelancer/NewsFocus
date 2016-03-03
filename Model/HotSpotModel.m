//
//  HotSpotModel.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "HotSpotModel.h"

@implementation HotSpotModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        NSArray *array = dic[@"imageurls"];
        NSDictionary *d = [array firstObject];
        _imageurls = d[@"url"];
        
        _title = dic[@"title"];
        _link = dic[@"link"];
        _source = dic[@"source"];
        
        
    }
    
    
    return self;
}



@end
