//
//  SliderViewController.h
//  LeftRightSlider
//
//  Created by Zhao Yiqi on 13-11-27.
//  Copyright (c) 2013年 Zhao Yiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController

@property(nonatomic,strong)UIViewController *LeftVC;
@property(nonatomic,strong)UIViewController *RightVC;
@property(nonatomic,strong)UIViewController *MainVC;

@property(nonatomic,strong)NSMutableDictionary *controllersDict;

//向左右滑动的时候 main视图 的偏移量
@property(nonatomic,assign)float LeftSContentOffset;
@property(nonatomic,assign)float RightSContentOffset;

//向左右滑动的时候 main视图 的缩放比例
@property(nonatomic,assign)float LeftSContentScale;
@property(nonatomic,assign)float RightSContentScale;

//当向左滑动之后 需要恢复原来的形状 需要向右滑动多少的距离 才能让其复原
@property(nonatomic,assign)float LeftSJudgeOffset;
@property(nonatomic,assign)float RightSJudgeOffset;
//滑动之后 持续的动画时间
@property(nonatomic,assign)float LeftSOpenDuration;
@property(nonatomic,assign)float RightSOpenDuration;
//关闭动画
@property(nonatomic,assign)float LeftSCloseDuration;
@property(nonatomic,assign)float RightSCloseDuration;
//是否显示 左边右边
@property(nonatomic,assign)BOOL canShowLeft;
@property(nonatomic,assign)BOOL canShowRight;

+ (SliderViewController*)sharedSliderController;

- (void)showContentControllerWithModel:(NSString*)className;
- (void)showLeftViewController;
- (void)showRightViewController;

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes;

@end
