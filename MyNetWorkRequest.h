//
//  MyNetWorkRequest.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//频道与新闻选择
typedef enum : NSUInteger {
    SelectChannelSearch,
    SelectNewsSearch,
} SelectSearch;
@interface MyNetWorkRequest : NSObject<NSURLConnectionDataDelegate>

+(void)NetWorkRequest:(SelectSearch)select ChannelID:(NSString *)channelId
     completionHandle:(void (^)(id))completionblock
          errorHandle:(void (^)(NSError *))errorblock;
@end
