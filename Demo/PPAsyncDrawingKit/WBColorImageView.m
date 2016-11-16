//
//  WBColorImageView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBColorImageView.h"

@implementation WBColorImageView

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [self setBackgroundColor:backgroundColor boolOwn:YES];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor boolOwn:(BOOL)boolOwn
{
    [super setBackgroundColor:backgroundColor];
    if (boolOwn) {
        self.commonBackgroundColor = backgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (!self.image) {
        if (highlighted) {
            [self setBackgroundColor:self.highLightBackgroundColor boolOwn:NO];
        } else {
            [self setBackgroundColor:self.commonBackgroundColor boolOwn:NO];
        }
    }
}
@end
