//
//  UIView+UIViewController.m
//  焦点新闻
//
//  Created by 金磊 on 15/8/28.
//  Copyright (c) 2015年 金磊. All rights reserved.
//

#import "UIView+UIViewController.h"
#import "MainAppViewController.h"
#import "QHMainGestureRecognizerViewController.h"
@implementation UIView (UIViewController)

- (QHMainGestureRecognizerViewController *)viewController {
    
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[QHMainGestureRecognizerViewController class]]) {
            return (QHMainGestureRecognizerViewController *)next;
        }
        
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}

@end