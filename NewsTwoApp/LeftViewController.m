//
//  LeftViewController.m
//  WYApp
//
//  Created by chen on 14-7-17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "LeftViewController.h"
#import "btRippleButtton.h"
#import "AppDelegate.h"
@interface LeftViewController ()
{
    NSArray *_arData;
}

@end

@implementation LeftViewController
- (void)viewDidLoad
{
    UIApplication *APP = [UIApplication sharedApplication];
    [APP setStatusBarStyle:UIStatusBarStyleLightContent];

    
    _arData = @[@"新闻", @"订阅", @"图片", @"视频", @"跟帖", @"电台"];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageBgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageBgV setImage:[UIImage imageNamed:@"Left.png"]];
    [self.view addSubview:imageBgV];
    
    __block float h = self.view.frame.size.height*0.7/[_arData count];
    __block float y = 0.15*self.view.frame.size.height;
    //用GCD遍历数组
    [_arData enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
    {
        UIView *listV = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, h)];
        listV.backgroundColor = [UIColor clearColor];
        
        BTRippleButtton *button = [[BTRippleButtton alloc]initWithImage:nil andFrame:CGRectMake(60, 0, 60, 60) andTarget:@selector(buttonAction:) andID:self andTitle:obj];
        [button setRippeEffectEnabled:YES];
        [button setRippleEffectWithColor:[UIColor redColor]];
        
        button.tag = idx + 1;
        [listV addSubview:button];
        [self.view addSubview:listV];
        y += h;
    }];
}

-(void)buttonAction:(BTRippleButtton *)button
{
    if (button.tag == 1) {
        NSLog(@"新闻");
    }
}

@end
