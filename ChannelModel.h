//
//  ChannelModel.h
// NewsFocus
//
//  Created by 金磊 on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelModel : NSObject
@property(nonatomic,strong)NSString *channedid;
@property(nonatomic,strong)NSString *channelName;
-(id)initWitdDic:(NSDictionary *)dic;
@end
