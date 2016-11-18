//
//  PPButton.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/27.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPButton.h"
#import "NSString+PPAsyncDrawingKit.h"

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
    _titles = @{}.mutableCopy;
    _titleColors = @{}.mutableCopy;
    _images = @{}.mutableCopy;
    _backgroundImages = @{}.mutableCopy;
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

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(NSDictionary *)userInfo
{
    CGContextSaveGState(context);
    CGContextSetInterpolationQuality(context, 1);
    PPButtonInfo *buttonInfo = self.buttonInfo;
    [buttonInfo.image drawInRect:self.imageFrame];
    [buttonInfo.backgroundImage drawInRect:self.backgroundFrame];
    self.titleFrame = CGRectMake(0, 0, 100, 32);
    [buttonInfo.title pp_drawInRect:self.titleFrame withFont:buttonInfo.titleFont textColor:buttonInfo.titleColor lineBreakMode:NSLineBreakByWordWrapping];
    CGContextRestoreGState(context);
    return YES;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    if (title) {
        self.titles[stateString] = title;
    } else {
        [self.titles removeObjectForKey:stateString];
    }
    if (self.state == state) {
        [self updateTitle:title];
    } else {
        
    }
}

- (void)updateTitle:(NSString *)title
{
    self.buttonInfo.title = title;
    self.buttonInfo.titleFont = [UIFont systemFontOfSize:18];
    self.buttonInfo.titleColor = [UIColor redColor];
    [self setNeedsUpdateFrame];
    [self setNeedsDisplay];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    
}

- (void)updateContentsAndRelayout:(BOOL)relayout
{
    [self updateButtonInfo];
    if (relayout) {
        [self setNeedsUpdateFrame];
    }
    [self setNeedsDisplay];
}

- (void)setNeedsUpdateFrame
{
    
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

