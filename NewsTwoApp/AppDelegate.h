//
//  AppDelegate.h
//  NewsTwoApp
//
//  Created by chen on 14/7/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
//授权
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,TencentSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TencentOAuth *oAuth;
@end
