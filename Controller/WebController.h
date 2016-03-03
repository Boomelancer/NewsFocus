//
//  WebController.h
//  焦点新闻
//
//  Created by 金磊 on 15/9/27.
//  Copyright © 2015年 金磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface WebController : UIViewController {
    MBProgressHUD *_hud;
}

@property (nonatomic,strong)NSString *link;

//第三方 MBProgressHUD

- (void)showHUD:(NSString *)title;

- (void)hideHUD;

//完成加载
- (void)completeHUD:(NSString *)title;

@end
