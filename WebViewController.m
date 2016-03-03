//
//  WebViewController.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/29.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import "WebViewController.h"
#import "HYActivityView.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) HYActivityView *activityView;
@end

@implementation WebViewController
{
    MBProgressHUD *HUD;
}

-(id)init
{
    if (self = [super init]) {
        
        _newsModel = [[NewsModel alloc]init];
    }
    return  self;
}
-(void)viewDidLoad
{
    [self _creatNavItem];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_longUrl]];
    self.view.backgroundColor = [UIColor grayColor];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
}

#pragma mark - 进度视图
//正在加载
-(void)HUDShowProgress:(NSString *)title
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    [HUD show:YES];
    HUD.dimBackground = YES;//有个遮罩层的作用 不能点击
}

-(void)hideHUD
{
    
    [HUD hide:YES];
}

//加载完成之后
-(void)completeHUD
{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"加载完成-";
    [HUD hide:YES afterDelay:1];
}
#pragma mark - 网络请求的协议方法
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self HUDShowProgress:@"正在加载"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self completeHUD];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)_creatNavItem
{
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(kScreenWidth - 10 - 80, 0, 60, 40);
    shareButton.backgroundColor = [UIColor clearColor];
    shareButton.titleLabel.textColor = [UIColor redColor];
    [shareButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
}
-(void)shareButtonAction
{
    if (!self.activityView) {
        
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:self.view];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 6;
        
        //分享到新浪微博
        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"share_platform_sina"] handler:^(ButtonView *buttonView){
            
        }];
        [self.activityView addButtonView:bv];
        
        //分享到163.com
        bv = [[ButtonView alloc]initWithText:@"Email" image:[UIImage imageNamed:@"share_platform_email"] handler:^(ButtonView *buttonView){
            NSLog(@"点击Email");
        }];
        [self.activityView addButtonView:bv];
        
        //分享到印象笔记
        bv = [[ButtonView alloc]initWithText:@"印象笔记" image:[UIImage imageNamed:@"share_platform_evernote"] handler:^(ButtonView *buttonView){
            NSLog(@"点击印象笔记");
        }];
        [self.activityView addButtonView:bv];
        
        //分享到QQ好友
        bv = [[ButtonView alloc]initWithText:@"QQ好友" image:[UIImage imageNamed:@"share_platform_qqfriends"] handler:^(ButtonView *buttonView){
            
            
            NSString *utf8String = _longUrl;
            NSString *title = _newsModel.NewsTitle;
            NSString *description = _newsModel.NewsDesc;
            NSString *previewImageUrl;
            if (_newsModel.NewsimgUrl == nil) {
                previewImageUrl = @"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg";
            }
            previewImageUrl = _newsModel.NewsimgUrl;
            NSURL *url = [NSURL URLWithString:previewImageUrl];
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:utf8String]
                                        title:title
                                        description:description
                                        previewImageURL:url];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            //将内容分享到qq
            [QQApiInterface sendReq:req];
            //将内容分享到qzone
            //QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];

        }];
        [self.activityView addButtonView:bv];
        
        //分享到QQ空间
        bv = [[ButtonView alloc]initWithText:@"QQ空间" image:[UIImage imageNamed:@"soRC3iqzYjEeo.jpg"] handler:^(ButtonView *buttonView){
           
            NSString *utf8String = _newsModel.NewsDetailLink;
            NSString *title = _newsModel.NewsTitle;
            NSString *description = _newsModel.NewsDesc;
            NSString *previewImageUrl;
            if (_newsModel.NewsimgUrl == nil) {
                previewImageUrl = @"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg";
            }
            previewImageUrl = _newsModel.NewsimgUrl;
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:utf8String]
                                        title:title
                                        description:description
                                        previewImageURL:[NSURL URLWithString:previewImageUrl]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            //将内容分享到qq
            //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            //将内容分享到qzone
            [QQApiInterface SendReqToQZone:req];

            
        }];
        [self.activityView addButtonView:bv];

        //分享到微信好友
        bv = [[ButtonView alloc]initWithText:@"微信" image:[UIImage imageNamed:@"share_platform_wechat"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信");
        }];
        [self.activityView addButtonView:bv];
        
        //分享到朋友圈
        bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"share_platform_wechattimeline"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信朋友圈");
        }];
        [self.activityView addButtonView:bv];
        
    }
    
    [self.activityView show];
}

@end
