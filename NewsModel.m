//
//  NewsModel.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

/*
 "channelId": "5572a109b3cdc86cf39001db",
 "channelName": "国内最新",
 "chinajoy": 0,
 "desc": "这两个核心功能整体上提高了应用系统的工作效率，增强了系统的可用性、稳定性和可扩展性，提升了用户体验。",
 "imageurls": [
 {
 "height": 119,
 "url": "http://img.ptcms.csdn.net/article/201509/26/56057f69014a7.jpg",
 "width": 169
 }
 ],
 "link": "http://www.csdn.net/article/2015-09-26/2825807",
 "nid": "4610457221427358137",
 "pubDate": "2015-09-26 12:25:43",
 "source": "CSDN",
 "title": "《程序员10月A刊：移动开发新看点》火热上市！"
 */

-(id)initWithDic:(NSDictionary *)Dic
{
    if (self = [super init]) {
        
//        NSDictionary *dic = JsonDic[@"showapi_res_body"];
//        NSDictionary *dic1 = dic[@"pagebean"];
//        NSArray *array = dic1[@"contentlist"];
        
        NSArray *array  = Dic[@"imageurls"];
        NSDictionary *dictionary = [array firstObject];
        _NewsimgUrl = dictionary[@"url"];
        //NSLog(@"url = %@",_NewsimgUrl);
        _NewsTitle = Dic[@"title"];
        _NewsDesc = Dic[@"desc"];
        _NewsDetailLink = Dic[@"link"];
        
        
    }
    return self;
}

@end
