//
//  PPAnimationExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/3/2.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPAnimationExample.h"
#import "PPButton.h"
#import "UIView+Frame.h"
#import "UIImage+Color.h"

typedef NS_ENUM(NSUInteger, PPAnimationState) {
    PPAnimationStateOriginal,
    PPAnimationStateTransform,
};

@interface PPAnimationExample ()
@property (nonatomic, strong) PPButton *button;
@property (nonatomic, assign) PPAnimationState rotateState;
@property (nonatomic, assign) PPAnimationState scaleState;
@property (nonatomic, assign) PPAnimationState translateState;
@property (nonatomic, assign) PPAnimationState alphaState;
@end

@implementation PPAnimationExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _button = [[PPButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_button setTitle:@"Animation" forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
    _button.center = self.view.center;
    [self.view addSubview:_button];
    
    CGFloat margin = 12.0f;
    __block CGFloat top = margin + 64.0f;
    
    NSArray *animations = @[@"Rotate", @"Scale", @"Translate", @"Alpha"];
    [animations enumerateObjectsUsingBlock:^(NSString *  _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:name forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blueColor];
        [button sizeToFit];
        button.origin = CGPointMake(margin, top);
        top += margin + button.height;
        [button addTarget:self action:NSSelectorFromString(name.lowercaseString) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }];
}

- (void)rotate
{
    CGFloat value = _rotateState == PPAnimationStateOriginal ? M_PI : 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
        [_button.layer setValue:@(value) forKeyPath:@"transform.rotation"];
    } completion:^(BOOL finished) {
        _rotateState = !_rotateState;
    }];
}

- (void)scale
{
    CGFloat value = _scaleState == PPAnimationStateOriginal ? 1.5f : 1.0f;
    [UIView animateWithDuration:0.5f animations:^{
        [_button.layer setValue:@(value) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        _scaleState = !_scaleState;
    }];
}

- (void)translate
{
    CGFloat value = _translateState == PPAnimationStateOriginal ? 50.0f : 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
        [_button.layer setValue:@(value) forKeyPath:@"transform.translation.x"];
    } completion:^(BOOL finished) {
        _translateState = !_translateState;
    }];
}

- (void)alpha
{
    CGFloat value = _alphaState == PPAnimationStateOriginal ? 0.5f : 1.0f;
    [UIView animateWithDuration:0.5f animations:^{
        _button.alpha = value;
    } completion:^(BOOL finished) {
        _alphaState = !_alphaState;
    }];
}

@end
