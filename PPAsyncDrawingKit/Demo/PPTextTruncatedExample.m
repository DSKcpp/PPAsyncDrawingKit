//
//  PPTextTruncatedExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/18.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPTextTruncatedExample.h"
#import <PPAsyncDrawingKit/PPTextView.h>
#import "UIView+Frame.h"

@interface PPTextTruncatedExample ()

@end

@implementation PPTextTruncatedExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 24.0f, CGFLOAT_MAX);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"(2016 年 10 月 27 日，加利福尼亚州，CUPERTINO) —— Apple® 今日推出了迄今为止最纤薄、最轻巧的 MacBook Pro®，并带来了创新的界面设计，以一条色彩绚丽、具备 Retina® 画质的 Multi-Touch™多点触控显示面板取代了以往键盘上排的功能键，这就是全新的 Multi-Touch Bar™。新一代 MacBook Pro 配备 Apple 迄今最明亮、最多彩的 Retina 显示屏，安全便捷的 Touch ID®，响应更灵敏的键盘，尺寸更大的 Force Touch 触控板，以及拥有双倍动态范围的音频系统。它还是有史以来性能最强大的 MacBook Pro：采用第六代四核和双核处理器，图形处理性能最高达前代机型的 2.3 倍，并拥有极其高速的固态硬盘和最多达四个 Thunderbolt 3 端口。"];
    [attributedString pp_setFont:[UIFont systemFontOfSize: 15.0f]];
    [attributedString pp_setColor:[UIColor blackColor]];
    
    PPTextView *textView = [[PPTextView alloc] init];
    textView.attributedString = attributedString;
    textView.numberOfLines = 5;
    textView.size = [attributedString pp_sizeConstrainedToSize:maxSize numberOfLines:5];
    textView.left = 12.0f;
    textView.top = 76.0f;
    [self.view addSubview:textView];
}



@end
