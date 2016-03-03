//
//  WebViewController.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/29.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "MBProgressHUD.h"

@interface WebViewController : UIViewController

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSString *longUrl;
@property(nonatomic,strong)NewsModel *newsModel;

@end
