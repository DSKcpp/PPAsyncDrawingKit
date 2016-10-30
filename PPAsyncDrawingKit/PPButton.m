//
//  PPButton.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/27.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPButton.h"

@implementation PPButtonInfo @end

@implementation PPButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.backgroundColor = [UIColor clearColor];
    self.drawingPolicy = 0;
    self.titles = @{}.mutableCopy;
    self.titleColors = @{}.mutableCopy;
    self.images = @{}.mutableCopy;
    self.backgroundImages = @{}.mutableCopy;
    self.reserveContentsBeforeNextDrawingComplete = YES;
    self.contentsChangedAfterLastAsyncDrawing = YES;
    [self setNeedsUpdateFrame];
    [self prepareDefaultValues];
}

- (void)prepareDefaultValues
{
    self.shouldDelayHighlighted = YES;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    PPButtonInfo *buttonInfo = [PPButtonInfo new];
    buttonInfo.titleFont = self.titleLabel.font;
    self.buttonInfo = buttonInfo;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.contentEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;
    NSString * state = [self stringOfState:UIControlStateNormal];
    [self.titleColors setObject:[UIColor blackColor] forKey:state];
}

- (void)asyncSetNeedsDisplay
{
    self.contentsChangedAfterLastAsyncDrawing = YES;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(self.frame, frame)) {
        [super setFrame:frame];
    }
    
}

- (void)updateContentsAndRelayout:(BOOL)relayout
{
    [self updateButtonInfo];
    if (relayout) {
        [self setNeedsUpdateFrame];
    }
    [self setNeedsDisplay];
}

- (void)didCommitBoundsSizeChange { }

- (NSString *)stringOfState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
            return @"UIControlStateNormal";
        case UIControlStateHighlighted:
            return @"UIControlStateNormal";
        case UIControlStateDisabled:
            return @"UIControlStateDisabled";
        case UIControlStateSelected:
            return @"UIControlStateSelected";
        case UIControlStateFocused:
            return @"UIControlStateFocused";
        case UIControlStateApplication:
            return @"UIControlStateApplication";
        case UIControlStateReserved:
            return @"UIControlStateReserved";
    }
}
@end

