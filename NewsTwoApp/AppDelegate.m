//
//  AppDelegate.m
//  NewsTwoApp
//
//  Created by chen on 14/7/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "AppDelegate.h"
#import "SliderViewController.h"
#import "MainAppViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "ViewController.h"


@implementation AppDelegate
{
//    WeixinViewController * WxVC;
//    SinaViewController * SinaVC;
//    TencentWBViewController * TcwbVC;
//    Reachability * hostReach;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableArray *array = [NSMutableArray array];
    
    UIApplication *APP = [UIApplication sharedApplication];
    [APP setStatusBarStyle:UIStatusBarStyleDefault];
    
    //腾讯授权对象
     _oAuth = [[TencentOAuth alloc]initWithAppId:kTencentAppID andDelegate:self];
    //主窗口
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    
    QHMainGestureRecognizerViewController *mainViewController = [[QHMainGestureRecognizerViewController alloc] init];
    //mainViewController.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
    mainViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"新闻" image:[UIImage imageNamed:@"news"] selectedImage:nil];
    ViewController *vc = [[ViewController alloc]init];
    //vc.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"关心" image:[UIImage imageNamed:@"love"] selectedImage:nil];
    //vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(50, 20);
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    [array addObject:nav1];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc];
    [array addObject:nav2];
    
    tabBarController.viewControllers = array;
    
    
    self.window.rootViewController = tabBarController;
    
    mainViewController.moveType = moveTypeMove;
    
    //设置左边 右 中间的控制器
    [SliderViewController sharedSliderController].LeftVC=[[LeftViewController alloc] init];
    [SliderViewController sharedSliderController].RightVC=[[RightViewController alloc] init];
    [SliderViewController sharedSliderController].MainVC = [[MainAppViewController alloc] init];
    //[SliderViewController sharedSliderController].LeftSOpenDuration = 2;
    
    //设置左滑动的时候主视图的向左的偏移量
    [SliderViewController sharedSliderController].RightSContentOffset=100;
    
    //设置当左右滑动的时候主视图的缩放比例
    [SliderViewController sharedSliderController].RightSContentScale=0.9;
    //当向左滑动之后 需要恢复原来的形状 需要向右滑动多少的距离 才能让其复原
    [SliderViewController sharedSliderController].RightSJudgeOffset=50;
    [mainViewController addViewController2Main:[SliderViewController sharedSliderController]];
    
    
//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//    
//    ViewController *vc = [[ViewController alloc]init];
//    
//    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
//    
//    self.window.rootViewController = navi;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




#pragma mark - 腾讯
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}

//返回用户信息 但是必须先实现 oauth 的getUserInfor 方法 一般在登录成功里面实现
- (void)getUserInfoResponse:(APIResponse*) response
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTencentUserInfor object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response,kTencentUserInfor, nil]];
}

//登录成功
-(void)tencentDidLogin
{
    [_oAuth getUserInfo];
    NSLog(@"登录成功");
}

-(void)tencentDidLogout
{
    NSLog(@"退出成功");
}

-(void)tencentDidNotNetWork
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无网络连接，请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (NO == [_oAuth getUserInfo]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"授权可能过期，请重新登录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
@end
