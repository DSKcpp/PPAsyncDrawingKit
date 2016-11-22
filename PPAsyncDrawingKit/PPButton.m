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
        [self.titles setObject:title forKey:stateString];
    } else {
        [self.titles removeObjectForKey:stateString];
    }
    if (self.state == state) {
        [self updateTitle:title];
    } else {
        
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    if (backgroundImage) {
        [self.backgroundImages setObject:backgroundImage forKey:stateString];
    } else {
        [self.backgroundImages removeObjectForKey:stateString];
    }
    if (self.state == state) {
        [self updateBackgroundImage:backgroundImage];
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    if (image) {
        [self.images setObject:image forKey:stateString];
    } else {
        [self.images removeObjectForKey:stateString];
    }
    if (self.state == state) {
        [self updateImage:image];
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    if ([self.titleColors objectForKey:stateString] != color) {
        if (color) {
            [self.titleColors setObject:color forKey:stateString];
        } else {
            [self.titleColors removeObjectForKey:stateString];
        }
        self.contentsChangedAfterLastAsyncDrawing = YES;
        [self setNeedsUpdateFrame];
        if (self.state == state) {
            self.titleLabel.textColor = color;
            self.buttonInfo.titleColor = color;
            [self asyncSetNeedsDisplay];
        }
    }
}

- (void)updateTitle:(NSString *)title
{
    if (![self.buttonInfo.title isEqualToString:title]) {
        self.buttonInfo.title = title;
        [self setNeedsUpdateFrame];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
}

- (void)updateImage:(UIImage *)image
{
    if (self.buttonInfo.image != image) {
        self.buttonInfo.image = image;
        
    }
}

- (void)updateBackgroundImage:(UIImage *)backgroundImage
{
    if (self.buttonInfo.backgroundImage != backgroundImage) {
        self.buttonInfo.backgroundImage = backgroundImage;
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

- (void)setNeedsUpdateFrame
{
    self.needsUpdateFrame = YES;
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

