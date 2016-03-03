//
//  SubInfoModel.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/28.
//  Copyright © 2015年 金磊. All rights reserved.
//

//订阅信息管理
#import <Foundation/Foundation.h>

@interface SubInfoModel : NSObject<NSCoding>

@property (nonatomic,strong) NSString *address;//接口地址
@property (nonatomic,strong) NSString *name;//栏目名
@property (nonatomic,strong) NSString *iconName;//图标名
@property (nonatomic,strong) NSNumber *isChosen;//是否已订阅

@end
