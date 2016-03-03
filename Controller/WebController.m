//
//  WebController.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import "WebController.h"
#import "Common.h"

@interface WebController ()<UIWebViewDelegate>

@end

@implementation WebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    web.delegate = self;
    web.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:_link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
    
    NSLog(@"%@",_link);
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    [button setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = btn;
    
    
}

- (void)shareAction {
}

- (void)showHUD:(NSString *)title {
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [_hud show:YES];
    _hud.labelText = title;
    
    //灰色背景视图覆盖掉其它视图
    _hud.dimBackground = YES;
    _hud.detailsLabelText = @"进度";
}

- (void)hideHUD {
    [_hud hide:YES];
}

- (void)completeHUD:(NSString *)title {
    _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:1.5];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"开始加载");
    [self showHUD:@"正在加载"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"加载完成");
    [self completeHUD:@"加载完成"];
    [webView stopLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"加载失败：%@",error);
    [self completeHUD:@"加载结束"];
    [webView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
