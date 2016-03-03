//
//  BTRippleButtton.m
//  BTSimpleRippleButton
//
//  Created by Balram Tiwari on 01/06/14.
//  Copyright (c) 2014 Balram. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BTRippleButtton.h"

@implementation BTRippleButtton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)commonInitWithImage:(UIImage *)image andFrame:(CGRect) frame andTitle:(NSString *)titleString{
    
    imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, frame.size.width-5, frame.size.height-5);
    imageView.layer.borderColor = [UIColor clearColor].CGColor;
    imageView.layer.borderWidth = 3;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.height/2;
    [self addSubview:imageView];
    
    imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.9].CGColor;
    //self.layer.backgroundColor = [UIColor redColor].CGColor;
    gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:gesture];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    title.center = imageView.center;
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = titleString;
    [self addSubview:title];
}

-(instancetype)initWithImage:(UIImage *)image
                    andFrame:(CGRect)frame
                   andTarget:(SEL)action
                       andID:(id)sender andTitle:(NSString *)titleString{
    self = [super initWithFrame:frame];
    
    if(self){
        [self commonInitWithImage:image andFrame:frame andTitle:titleString];
        methodName = action;
        superSender = sender;
    }
    
    return self;
}

-(instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame andTitle:(NSString *)titleString onCompletion:(completion)completionBlock {
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self commonInitWithImage:image andFrame:frame andTitle:titleString];
        self.block = completionBlock;
    }
    
    return self;
}


-(void)setRippleEffectWithColor:(UIColor *)color {
    rippleColor = color;
}

-(void)setRippeEffectEnabled:(BOOL)enabled {
    isRippleOn = enabled;
}

-(void)handleTap:(id)sender {

    if (isRippleOn) {
        UIColor *stroke = rippleColor ? rippleColor : [UIColor colorWithWhite:0.8 alpha:0.8];
        
        CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
        
        // accounts for left/right offset and contentOffset of scroll view
        CGPoint shapePosition = [self convertPoint:self.center fromView:self.superview];
        
        CAShapeLayer *circleShape = [CAShapeLayer layer];
        circleShape.path = path.CGPath;
        circleShape.position = shapePosition;
        circleShape.fillColor = [UIColor clearColor].CGColor;
        circleShape.opacity = 0;
        circleShape.strokeColor = stroke.CGColor;
        circleShape.lineWidth = 3;
        
        [self.layer addSublayer:circleShape];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)];
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @1;
        alphaAnimation.toValue = @0;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        animation.animations = @[scaleAnimation, alphaAnimation];
        animation.duration = 0.8f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [circleShape addAnimation:animation forKey:nil];
    }
    //[UIColor colorWithWhite:1 alpha:0.9].CGColor
    [UIView animateWithDuration:0.1 animations:^{
        imageView.alpha = 0.4;
        self.layer.borderColor = [UIColor yellowColor].CGColor ;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            imageView.alpha = 1;
            self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.9].CGColor;
        }completion:^(BOOL finished) {
            if([superSender respondsToSelector:methodName]){
                [superSender performSelectorOnMainThread:methodName withObject:nil waitUntilDone:NO];
            }
            
            if(_block) {
                BOOL success= YES;
                _block(success);
            }
        }];
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
