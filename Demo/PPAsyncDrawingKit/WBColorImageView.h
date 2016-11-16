//
//  WBColorImageView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBColorImageView : UIImageView
@property(retain, nonatomic) UIView *bottomLineView;
@property(retain, nonatomic) UIView *topLineView;
@property(retain, nonatomic) UIColor *commonBackgroundColor;
@property(retain, nonatomic) UIColor *highLightBackgroundColor;

- (void)setBackgroundColor:(UIColor *)backgroundColor boolOwn:(BOOL)boolOwn;
- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)setHighlighted:(BOOL)highlighted;
@end
