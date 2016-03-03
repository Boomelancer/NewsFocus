//
//  HotSpotModel.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

//我的apiKey:728d1337530f3f3469bcb455872a5a79

#import <Foundation/Foundation.h>

@interface HotSpotModel : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *source;
@property (nonatomic,strong) NSString *imageurls;
@property (nonatomic,strong) NSString *link;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
