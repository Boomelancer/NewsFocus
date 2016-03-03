//
//  SubScribeModel.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubScribeModel : NSObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *picUrl;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
