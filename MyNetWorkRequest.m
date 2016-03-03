//
//  MyNetWorkRequest.m
//  焦点新闻
//
//  Created by 金磊on 15/9/26.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import "MyNetWorkRequest.h"
@implementation MyNetWorkRequest

//select :频道与新闻选择
//channelid：根据频道id 查询新闻
+(void)NetWorkRequest:(SelectSearch)select ChannelID:(NSString *)channelId
     completionHandle:(void (^)(id))completionblock
          errorHandle:(void (^)(NSError *))errorblock
{
    NSString *urlString;
    NSString *paramString;
    
    //频道搜索
    if (select == SelectChannelSearch) {
        
        urlString = BaseUrlChannel;
        paramString = @"";
    }
    else if (select == SelectNewsSearch)//新闻搜索
    {
        urlString = BaseUrlNews;
        
        NSString *s = @"";
        paramString = [NSString stringWithFormat:@"channelId=%@%@",channelId,s];
        
    }
   
    [self request:urlString withHttpArg:paramString completeHandel:completionblock errorHandle:errorblock];
}

+(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  completeHandel:(void (^)(id))completionblock errorHandle:(void (^)(NSError *))errorblock {
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"674c9b3aaa1b4425e42ba1be525df445" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                  // NSLog(@"%@",responseString);
                                   //json解析之后的数据
                                   completionblock(data);
                                   
                                   //将解析过的json数据放在plist文件中
//                                   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ChannelData" ofType:@"plist"];
//                                   [jsonDic writeToFile:filePath atomically:YES];
                                   //将数据放到json文件中
                                   //completionblock(data);
                               }
                           }];
}
@end
