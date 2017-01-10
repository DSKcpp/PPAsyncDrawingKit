//
//  PPButtonExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/10.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPButtonExample.h"
#import "PPButton.h"
#import "UIView+Frame.h"
#import "UIImage+Color.h"

@interface PPButtonExample ()

@end

@implementation PPButtonExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    PPButton *button = [[PPButton alloc] init];
    [button setTitle:@"Normal" forState:UIControlStateNormal];
    [button setTitle:@"Highlighted" forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [button setTitleFont:[UIFont systemFontOfSize:20.0f]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchCancel];
    [button addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(TouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    button.size = CGSizeMake(200, 100);
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)touchDown:(PPButton *)button
{
    NSLog(@"UIControlEventTouchDown");
}

- (void)touchUpInside:(PPButton *)button
{
    NSLog(@"UIControlEventTouchUpInside");
}

- (void)touchCancel:(PPButton *)button
{
    NSLog(@"UIControlEventTouchCancel");
}

- (void)touchUpOutside:(PPButton *)button
{
    NSLog(@"UIControlEventTouchUpOutside");
}

- (void)touchDragInside:(PPButton *)button
{
    NSLog(@"UIControlEventTouchDragInside");
}

- (void)TouchDragOutside:(PPButton *)button
{
    NSLog(@"UIControlEventTouchDragOutside");
}
@end
