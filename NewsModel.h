//
//  NewsModel.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property(nonatomic,strong)NSString *NewsimgUrl;
@property(nonatomic,strong)NSString *NewsTitle;
@property(nonatomic,strong)NSString *NewsDesc;
@property(nonatomic,strong)NSString *NewsDetailLink;

-(id)initWithDic:(NSDictionary *)dic;
@end
