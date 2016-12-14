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

@interface PPButton ()
@property (nonatomic, copy) NSString *renderedTitle;
@property (nonatomic, strong) UIImage *renderedImage;
@property (nonatomic, strong) UIImage *renderedBackgroundImage;
@property (nonatomic, assign) CGSize renderedBoundsSize;
@end

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
    NSUInteger drawingCount= self.drawingCount;
    PPButtonInfo *buttonInfo = self.buttonInfo;
    if (buttonInfo) {
        [self updateSubviewFrames];
        if (drawingCount == self.drawingCount) {
            UIImage *backgroundImage = buttonInfo.backgroundImage;
            UIImage *image = buttonInfo.image;
            UIColor *titleColor = buttonInfo.titleColor;
            NSString *title = buttonInfo.title;
            UIFont *titleFont = buttonInfo.titleFont;
            CGRect backgroundFrame = self.backgroundFrame;
            CGRect imageFrame = self.imageFrame;
            CGRect titleFrame = self.titleFrame;
            if (drawingCount == self.drawingCount) {
                CGContextSaveGState(context);
                CGContextSetInterpolationQuality(context, kCGInterpolationNone);
                [backgroundImage drawInRect:backgroundFrame];
                if (drawingCount == self.drawingCount) {
                    [image drawInRect:imageFrame];
                    if (title) {
                        [title pp_drawInRect:titleFrame withFont:titleFont textColor:titleColor lineBreakMode:NSLineBreakByWordWrapping];
                    } else {
                        
                    }
                    if (drawingCount == self.drawingCount) {
                        CGContextRestoreGState(context);
                        _renderedImage = image;
                        _renderedTitle = title;
                        _renderedBackgroundImage = backgroundImage;
//                        _renderedBoundsSize = 
                    }
                }
            }
        }
    }
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

- (void)updateSubviewFrames
{
    if (_needsUpdateFrame) {
        [self actualUpdateSubviewFrames];
    }
}

- (void)actualUpdateSubviewFrames
{
    CGRect bounds = self.bounds;
    UIEdgeInsets contentEdgeInsets = _contentEdgeInsets;
    CGFloat x = CGRectGetMinX(bounds);
    CGFloat y = CGRectGetMinY(bounds);
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    self.backgroundFrame = self.bounds;
    CGSize imageSize = _buttonInfo.image.size;
        CGSize titleSize = [_buttonInfo.title pp_sizeWithFont:_buttonInfo.titleFont constrainedToSize:CGSizeMake(width - imageSize.width, height) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat totalW = imageSize.width + titleSize.width;
    CGFloat left = (width - totalW) / 2.0f;
    self.imageFrame = CGRectMake(left, height / 2.0f - imageSize.height / 2.0f, imageSize.width, imageSize.height);
    self.titleFrame = CGRectMake(CGRectGetMaxX(self.imageFrame), height / 2.0f - titleSize.height / 2.0f, titleSize.width, titleSize.height);
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

