//
//  RightViewController.m
//  WYApp
//
//  Created by chen on 14-7-17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "RightViewController.h"
#import "UIImageView+WebCache.h"
@implementation RightViewController
{
    UILabel *_addressLable;
    UILabel *_nickNameLable;
}

- (void)viewDidLoad
{
    
    UIApplication *APP = [UIApplication sharedApplication];
    [APP setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hostUserInfor:) name:kTencentUserInfor object:nil];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    UIImageView *imageBgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageBgV setImage:[UIImage imageNamed:@"Left.png"]];
    [self.view addSubview:imageBgV];
    imageBgV.userInteractionEnabled = YES;
    
    float y = 0.15*self.view.frame.size.height;
    // 头像
    _headImageView = [[UIImageView alloc] init];
    _headImageView.backgroundColor = [UIColor clearColor];
    _headImageView.frame = CGRectMake(self.view.center.x + 80 + 50 - 40*0.7, y - 50, 60, 60);
    _headImageView.layer.cornerRadius = 30.0;
    _headImageView.layer.borderWidth = 1.0;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.image = [UIImage imageNamed:@"head1.jpg"];
    [imageBgV addSubview:_headImageView];
    _headImageView.userInteractionEnabled = YES;
    //设置手势
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [singleTapRecognizer addTarget:self action:@selector(headPhotoAnimation)];
    [_headImageView addGestureRecognizer:singleTapRecognizer];
    
    //设置显示地址和昵称的标签
    _addressLable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x + 80, y - 50 +60, 100, 40)];
    _nickNameLable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x + 80, y - 50 + 30 + 50, 100, 40)];
    
    _addressLable.textAlignment = NSTextAlignmentCenter;
    _addressLable.font = [UIFont systemFontOfSize:15];
    _addressLable.textColor = [UIColor whiteColor];
    
    _nickNameLable.textAlignment = NSTextAlignmentCenter;
    _nickNameLable.font = [UIFont systemFontOfSize:15];
    _nickNameLable.textColor = [UIColor whiteColor];
    
    
    
    [self.view addSubview:_addressLable];
    [self.view addSubview:_nickNameLable];
}

- (void)headPhotoAnimation
{
    //图片旋转
    [self rotate360WithDuration:1.0 repeatCount:1];
    _headImageView.animationDuration = 1.0;
    _headImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"head1.jpg"],
                                      [UIImage imageNamed:@"head2.jpg"],[UIImage imageNamed:@"head2.jpg"],
                                      [UIImage imageNamed:@"head2.jpg"],[UIImage imageNamed:@"head2.jpg"],
                                      [UIImage imageNamed:@"head1.jpg"], nil];
    _headImageView.animationRepeatCount = 1;
    [_headImageView startAnimating];
    
    //发送登陆请求
    [self _reloadData];
}

- (void)rotate360WithDuration:(CGFloat)aDuration repeatCount:(CGFloat)aRepeatCount
{
    //关键帧动画
	CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
	theAnimation.values = [NSArray arrayWithObjects:
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0,1,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0,1,0)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2*M_PI, 0,1,0)],
						   nil];
	theAnimation.cumulative = YES;
	theAnimation.duration = aDuration;
	theAnimation.repeatCount = aRepeatCount;
	theAnimation.removedOnCompletion = YES;
    
	[_headImageView.layer addAnimation:theAnimation forKey:@"transform"];
}


#pragma mark - 腾讯登陆获取授权
//发送登陆请求
-(void)_reloadData
{
    //授权信息 不要太多 否则用户会觉得烦
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];
    //获得授权对象
    TencentOAuth *oAuth = [self getInstanceOAuth];
    //网路请求
    [oAuth authorize:permissions inSafari:NO];
    
}

/*
 city = "\U676d\U5dde";
 figureurl = "http://qzapp.qlogo.cn/qzapp/1104779377/988488464E614A420D5FC6851AFF514B/30";
 "figureurl_1" = "http://qzapp.qlogo.cn/qzapp/1104779377/988488464E614A420D5FC6851AFF514B/50";
 "figureurl_2" = "http://qzapp.qlogo.cn/qzapp/1104779377/988488464E614A420D5FC6851AFF514B/100";
 "figureurl_qq_1" = "http://q.qlogo.cn/qqapp/1104779377/988488464E614A420D5FC6851AFF514B/40";
 "figureurl_qq_2" = "http://q.qlogo.cn/qqapp/1104779377/988488464E614A420D5FC6851AFF514B/100";
 gender = "\U7537";
 "is_lost" = 0;
 "is_yellow_vip" = 0;
 "is_yellow_year_vip" = 0;
 level = 0;
 msg = "";
 nickname = "\U4f60\U662f\U8c01\Uff0c\U4fbf\U9047\U89c1\U8c01";
 province = "\U6d59\U6c5f";
 ret = 0;
 vip = 0;
 "yellow_vip_level" = 0;
 }
 
 */
//获取用户信息 
-(void)hostUserInfor:(NSNotification *)notification
{
    //返回的事json格式的数据 需要json解析 得到用户的个人信息
    APIResponse *response = notification.userInfo[kTencentUserInfor];
    NSDictionary *dic = response.jsonResponse;
    //头像
    [_headImageView sd_setImageWithURL:dic[@"figureurl_qq_2"]];
    _nickNameLable.text = dic[@"nickname"];
    _addressLable.text = [NSString stringWithFormat:@"%@ %@",dic[@"province"],dic[@"city"]];
}

//得到授权对象 保证程序中只有一个oauth对象
-(TencentOAuth *)getInstanceOAuth
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.oAuth;
}

@end
