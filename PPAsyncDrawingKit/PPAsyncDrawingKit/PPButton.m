//
//  PPButton.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/27.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPButton.h"
#import "NSString+PPAsyncDrawingKit.h"

@interface PPButtonInfo : NSObject
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *image;

@end

@implementation PPButtonInfo @end

@interface PPButton ()
{
    NSMutableDictionary<NSString *, UIImage *> *_backgroundImages;
    NSMutableDictionary<NSString *, UIImage *> *_images;
    NSMutableDictionary<NSString *, UIColor *> *_titleColors;
    NSMutableDictionary<NSString *, NSString *> *_titles;
    
    CGRect _backgroundFrame;
    CGRect _imageFrame;
    CGRect _titleFrame;
    
    PPButtonInfo *_buttonInfo;
    NSString *_renderedTitle;
    UIImage *_renderedImage;
    UIImage *_renderedBackgroundImage;
    CGSize _renderedBoundsSize;
    
    BOOL _privateTracking;
    BOOL _needsUpdateFrame;
}
@end

@implementation PPButton
{
    struct {
        BOOL titleChange;
        BOOL imageChange;
        BOOL backgroundImageChange;
        BOOL boundsSizeChange;
    } _pending;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (self.isHighlighted != highlighted) {
        [super setHighlighted:highlighted];
//        if (_privateTracking == NO) {
//            if (_trackingState == UIControlStateHighlighted) {
//                
//            }
            [self updateContentsAndRelayout:NO];
//        }
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (self.isEnabled != enabled) {
        [super setEnabled:enabled];
        CGFloat alpha;
        if (!enabled || self.state == UIControlStateDisabled) {
            _trackingState = UIControlStateDisabled;
            alpha = 0.5f;
        } else {
            _trackingState = UIControlStateNormal;
            alpha = 1.0f;
        }
        self.alpha = alpha;
    }
}

- (void)configure
{
    _titles = @{}.mutableCopy;
    _titleColors = @{}.mutableCopy;
    _images = @{}.mutableCopy;
    _backgroundImages = @{}.mutableCopy;
    self.clearsContextBeforeDrawing = NO;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    PPButtonInfo *buttonInfo = [PPButtonInfo new];
    buttonInfo.titleFont = _titleFont;
    _buttonInfo = buttonInfo;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.contentEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;
    NSString * state = [self stringOfState:UIControlStateNormal];
    [_titleColors setObject:[UIColor blackColor] forKey:state];
    [self setNeedsUpdateFrame];
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(self.frame, frame)) {
        [super setFrame:frame];
    }
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo
{
    NSUInteger drawingCount= self.drawingCount;
    PPButtonInfo *buttonInfo = _buttonInfo;
    if (buttonInfo) {
        [self updateSubviewFrames];
        if (drawingCount == self.drawingCount) {
            UIImage *backgroundImage = buttonInfo.backgroundImage;
            UIImage *image = buttonInfo.image;
            UIColor *titleColor = buttonInfo.titleColor;
            NSString *title = buttonInfo.title;
            UIFont *titleFont = _titleFont;
            CGRect backgroundFrame = _backgroundFrame;
            CGRect imageFrame = _imageFrame;
            CGRect titleFrame = _titleFrame;
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
    NSString *currentTitle = _titles[stateString];
    if ((title || currentTitle) && ![title isEqualToString:currentTitle]) {
        if (title) {
            [_titles setObject:title forKey:stateString];
        } else {
            [_titles removeObjectForKey:stateString];
        }
        if (self.state == state) {
            [self updateTitle:title];
        } else {
            BOOL stateEqualNormal = state == UIControlStateNormal;
            if (!self.state) {
                
            }
        }
    }

}

- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    UIImage *img = _backgroundImages[stateString];
    if (img != backgroundImage) {
        if (backgroundImage) {
            [_backgroundImages setObject:backgroundImage forKey:stateString];
        } else {
            [_backgroundImages removeObjectForKey:stateString];
        }
        if (self.state == state) {
            [self updateBackgroundImage:backgroundImage];
        }
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    if (image) {
        [_images setObject:image forKey:stateString];
    } else {
        [_images removeObjectForKey:stateString];
    }
    if (self.state == state) {
        [self updateImage:image];
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    if ([_titleColors objectForKey:stateString] != color) {
        if (color) {
            [_titleColors setObject:color forKey:stateString];
        } else {
            [_titleColors removeObjectForKey:stateString];
        }
        [self setNeedsUpdateFrame];
        if (self.state == state) {
//            self.titleLabel.textColor = color;
            _buttonInfo.titleColor = color;
            [self setNeedsDisplayAsync];
        }
    }
}

- (UIImage *)imageForState:(UIControlState)state
{
    NSString *stateKey = [self stringOfState:state];
    return _images[stateKey];
}

- (NSString *)titleForState:(UIControlState)state
{
    NSString *stateKey = [self stringOfState:state];
    return _titles[stateKey];
}

- (UIImage *)backgroundImageForState:(UIControlState)state
{
    NSString *stateKey = [self stringOfState:state];
    return _backgroundImages[stateKey];
}

- (UIColor *)titleColorForState:(UIControlState)state
{
    NSString *stateKey = [self stringOfState:state];
    return _titleColors[stateKey];
}

- (void)updateTitle:(NSString *)title
{
    PPButtonInfo *buttonInfo = _buttonInfo;
    if (![buttonInfo.title isEqualToString:title]) {
        buttonInfo.title = title;
        if (!_pending.titleChange) {
            _pending.titleChange = YES;
            [self setNeedsUpdateFrame];
            dispatch_async(dispatch_get_main_queue(), ^{
                _pending.titleChange = NO;
                if (![buttonInfo.title isEqualToString:_renderedTitle]) {
                    [self setNeedsUpdateFrame];
                    [self setNeedsDisplayAsync];
                }
            });
        }
    }
}

- (void)updateImage:(UIImage *)image
{
    PPButtonInfo *buttonInfo = _buttonInfo;
    if (buttonInfo.image != image) {
        buttonInfo.image = image;
        if (!_pending.imageChange) {
            _pending.imageChange = YES;
            [self setNeedsUpdateFrame];
            dispatch_async(dispatch_get_main_queue(), ^{
                _pending.imageChange = NO;
                if (buttonInfo.image != _renderedImage) {
                    [self setNeedsUpdateFrame];
                    [self setNeedsDisplayAsync];
                }
            });
        }
    }
}

- (void)updateBackgroundImage:(UIImage *)backgroundImage
{
    PPButtonInfo *buttonInfo = _buttonInfo;
    if (buttonInfo.backgroundImage != backgroundImage) {
        buttonInfo.backgroundImage = backgroundImage;
        if (!_pending.backgroundImageChange) {
            _pending.backgroundImageChange = YES;
            [self setNeedsUpdateFrame];
            dispatch_async(dispatch_get_main_queue(), ^{
                _pending.backgroundImageChange = NO;
                UIImage *bgImg = buttonInfo.backgroundImage;
                if (bgImg != _renderedBackgroundImage) {
                    [self setNeedsUpdateFrame];
                    [self setNeedsDisplayAsync];
                }
            });
        }
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

- (void)updateButtonInfo
{
    NSString *stateKey = [self stringOfState:_trackingState];
    NSString *normalStateKey = [self stringOfState:UIControlStateNormal];
    UIImage *backgroundImage = _backgroundImages[stateKey];
    if (!backgroundImage) {
        backgroundImage = _backgroundImages[normalStateKey];
        [self setNeedsUpdateFrame];
    }
    
    UIImage *image = _images[stateKey];
    BOOL imageIfNil = image == nil;
    if (!image) {
        imageIfNil = _trackingState == UIControlStateHighlighted;
    }
    if (imageIfNil) {
        image = _images[normalStateKey];
        [self setNeedsUpdateFrame];
    }
    
    UIColor *titleColor = _titleColors[stateKey];
    BOOL titleColorIfNil = titleColor == nil;
    if (!titleColor) {
        titleColorIfNil = _trackingState == UIControlStateHighlighted;
    }
    if (titleColorIfNil) {
        titleColor = _titleColors[normalStateKey];
    }
    
    NSString *title = _titles[stateKey];
    BOOL titleIfNil = title == nil;
    if (!title) {
        titleIfNil = _trackingState == UIControlStateHighlighted;
    }
    if (titleIfNil) {
        title = _titles[normalStateKey];
        [self setNeedsUpdateFrame];
    }
    
    PPButtonInfo *buttonInfo = _buttonInfo;
    buttonInfo.backgroundImage = backgroundImage;
    buttonInfo.image = image;
    buttonInfo.title = title;
    buttonInfo.titleColor = titleColor;
    buttonInfo.titleFont = _titleFont;
}

- (void)setNeedsUpdateFrame
{
    _needsUpdateFrame = YES;
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
    
    _backgroundFrame = UIEdgeInsetsInsetRect(bounds, contentEdgeInsets);
    CGSize imageSize = _buttonInfo.image.size;
    CGSize titleSize = [_buttonInfo.title pp_sizeWithFont:_titleFont constrainedToSize:CGSizeMake(width - imageSize.width, height) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat totalW = imageSize.width + titleSize.width;
    CGFloat left = (width - totalW) / 2.0f;
    _imageFrame = CGRectMake(left, height / 2.0f - imageSize.height / 2.0f, imageSize.width, imageSize.height);
    _titleFrame = CGRectMake(CGRectGetMaxX(_imageFrame), height / 2.0f - titleSize.height / 2.0f, titleSize.width, titleSize.height);
    _needsUpdateFrame = NO;
}   

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _privateTracking = YES;
    _trackingState = UIControlStateHighlighted;
    [self updateContentsAndRelayout:NO];
    return YES;
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = CGPointZero;
    if (touch) {
        point = [touch locationInView:self];
    }
    BOOL isCancel = CGRectContainsPoint(self.bounds, point);
    if (!isCancel) {
        [self sendActionsForControlEvents:UIControlEventTouchCancel];
        [self cancelTrackingWithEvent:event];
    }
    return isCancel;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _trackingState = UIControlStateNormal;
    [self updateContentsAndRelayout:NO];
    _privateTracking = NO;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    _trackingState = UIControlStateNormal;
    [self updateContentsAndRelayout:NO];
    _privateTracking = NO;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        [self setNeedsDisplay];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview) {
        [self setNeedsDisplay];
    }
}

- (void)didCommitBoundsSizeChange { }

- (NSString *)stringOfState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
            return @"UIControlStateNormal";
        case UIControlStateHighlighted:
            return @"UIControlStateHighlighted";
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
