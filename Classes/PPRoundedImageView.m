//
//  PPRoundedImageView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/22.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPRoundedImageView.h"
#import "PPAsyncDrawingKitUtilities.h"

@implementation PPRoundedImageView
{
    CGPathRef roundPathRef;
    CGPathRef borderPathRef;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.roundedCorners = UIRectCornerAllCorners;
        self.showsCornerRadius = YES;
        self.userInteractionEnabled = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        self.borderWidth = 0.0f;
        self.clipsToBounds = YES;
        self.updatePathWhenViewSizeChanges = YES;
        [self setDrawingPolicy:1];
        self.useUIImageView = NO;
        self.imageLayer = [CALayer layer];
        [self.layer addSublayer:self.imageLayer];
        self.isNeedChangeContentModel = NO;
    }
    return self;
}

- (instancetype)initWithCornerRadius:(CGFloat)cornerRadius
{
    return [self initWithCornerRadius:cornerRadius byRoundingCorners:UIRectCornerAllCorners];
}

- (instancetype)initWithCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)roundingCorners
{
    if (self = [self init]) {
        self.cornerRadius = cornerRadius;
        self.roundedCorners = roundingCorners;
    }
    return self;
}

- (instancetype)initWithCachedRoundPath:(CGPathRef)roundPath borderPath:(CGPathRef)borderPath
{
    if (self = [self init]) {
        roundPathRef = CGPathRetain(roundPath);
        borderPathRef = CGPathRetain(borderPath);
        self.updatePathWhenViewSizeChanges = NO;
    }
    return self;
}

- (void)setShowsCornerRadius:(BOOL)showsCornerRadius
{
    if (_showsCornerRadius == showsCornerRadius) {
        return;
    }
    _showsCornerRadius = showsCornerRadius;
    [self setNeedsDisplay];
}

- (void)setRoundedCorners:(UIRectCorner)roundedCorners
{
    if (_roundedCorners == roundedCorners) {
        return;
    }
    _roundedCorners = roundedCorners;
    CGPathRelease(roundPathRef);
    roundPathRef = nil;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (cornerRadius <= 0) {
        CGPathRelease(roundPathRef);
        roundPathRef = nil;
        [self setNeedsDisplay];
    }
    self.layer.cornerRadius = cornerRadius;
    if (_useUIImageView) {
        
    }
    self.internalMaskView.layer.cornerRadius = cornerRadius;
}

- (void)setShowsBorderCornerRadius:(BOOL)showsBorderCornerRadius
{
    if (_showsBorderCornerRadius == showsBorderCornerRadius) {
        return;
    }
    _showsBorderCornerRadius = showsBorderCornerRadius;
    CGPathRelease(borderPathRef);
    borderPathRef = nil;
    [self setNeedsDisplay];
}

- (void)setMaskColor:(UIColor *)maskColor
{
    if (_maskColor != maskColor) {
        _maskColor = maskColor;
        [self setNeedsDisplay];
        if (_useUIImageView) {
            if (!maskColor) {
                self.maskView.hidden = true;
            }
            self.maskView.backgroundColor = maskColor;
        }
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (_borderWidth != borderWidth) {
        _borderWidth = borderWidth;
        [self setNeedsDisplay];
    }
    if (_useUIImageView) {
        self.layer.borderWidth = borderWidth;
    } else {
        self.layer.borderWidth = 0.0f;
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (_borderColor != borderColor) {
        _borderColor = borderColor;
        [self setNeedsDisplay];
    }
    if (_useUIImageView) {
        self.layer.borderColor = borderColor.CGColor;
    } else {
        self.layer.borderColor = nil;
    }
}

- (void)setImage:(UIImage *)image
{
    if (_image == image) {
        if (_useUIImageView) {
            
        } else {
            if (image == nil || self.layer.contents == nil) {
                self.contentsChangedAfterLastAsyncDrawing = YES;
                [self setNeedsDisplay];
            }
        }
    } else {
        self.contentsChangedAfterLastAsyncDrawing = YES;
        if ([image isKindOfClass:[NSData class]]) {
            
        } else {
            if ([image isKindOfClass:[UIImage class]]) {
                
            } else {
                
            }
        }
        _image = image;
        [self setNeedsDisplay];
    }
//    self.useUIImageView = YES;
//    if (_image == image) {
//
//    } else {
//        [self setContentsChangedAfterLastAsyncDrawing:YES];
//        _image = image;
//        [self setNeedsDisplay];
//    }
}

- (void)setFillColor:(UIColor *)fillColor
{
    if (_fillColor != fillColor) {
        _fillColor = fillColor;
        [self setNeedsDisplay];
    }
}

- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors
{
    if (_gradientColors != gradientColors) {
        _gradientColors = gradientColors;
        self.gradientColorsUpdated = YES;
        [self setNeedsDisplay];
    }
}

- (void)setGradientColorRect:(CGRect)gradientColorRect
{
    if (!CGRectEqualToRect(_gradientColorRect, gradientColorRect)) {
        [self setNeedsDisplay];
    }
}

- (void)setUseUIImageView:(BOOL)useUIImageView
{
    if (_useUIImageView != useUIImageView) {
        _useUIImageView = useUIImageView;
        [self setNeedsDisplay];
        if (useUIImageView) {
            self.imageLayer.frame = _imageContentFrame;
        }
    } else {
        if (_useUIImageView) {
            
        } else {
            BOOL b1 = NO;
            if (_image == nil) {
                b1 = YES;
            }
            if (self.layer.contents) {
                
            }
        }
    }
}

- (void)setImageContentFrame:(CGRect)imageContentFrame
{
    if (!CGRectEqualToRect(_imageContentFrame, imageContentFrame)) {
        _imageContentFrame = imageContentFrame;
        if (self.useUIImageView) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _imageLayer.frame = imageContentFrame;
        }
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    self.imageContentFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)displayLayer:(CALayer *)layer
{
    if (_useUIImageView) {
        
    } else {
        [super displayLayer:layer];
    }
//    if (_useUIImageView) {
//        if (_isNeedChangeContentModel) {
//            if (_imageLayer.contents != (id)_image.CGImage) {
//                _imageLayer.contents = (__bridge id _Nullable)(_image.CGImage);
//            }
//        } else {
//            _imageLayer.contents = nil;
//            if (self.layer.contents != (id)_image.CGImage) {
//                self.layer.contents = (__bridge id _Nullable)_image.CGImage;
//            }
//        }
//    } else {
//        [super displayLayer:layer];
//    }
}

- (NSDictionary *)currentDrawingUserInfo
{
    return [self drawingComponentDictionary];
}

- (NSDictionary *)drawingComponentDictionary
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setSafeObject:self.image forKey:@"image"];
    [userInfo setSafeObject:self.fillColor forKey:@"fillColor"];
    [userInfo setSafeObject:self.gradientColors forKey:@"gradientColors"];
    [userInfo setSafeObject:self.maskColor forKey:@"maskColor"];
    if (!CGRectEqualToRect(CGRectZero, self.gradientColorRect)) {
        [userInfo setSafeObject:[NSValue valueWithCGRect:self.gradientColorRect] forKey:@"gradientColorRect"];
    }
    if (self.showsCornerRadius) {
        CGPathRef path = CreateCGPath(self.bounds, self.cornerRadius, self.roundedCorners);
        roundPathRef = path;
        [userInfo setSafeObject:(__bridge id _Nonnull)(path) forKey:@"roundPath"];
    }
    if (!CGRectIsEmpty(self.imageContentFrame)) {
        [userInfo setSafeObject:[NSValue valueWithCGRect:self.imageContentFrame] forKey:@"imageFrame"];
    }
    return userInfo;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(NSDictionary *)userInfo
{
    [self drawWithContext:context inRect:rect withComponents:userInfo];
    return YES;
}

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)rect withComponents:(NSDictionary *)components
{
    if (self.showsCornerRadius) {
        CGPathRef path = (__bridge CGPathRef)(components[@"roundPath"]);
        if (path) {
            CGContextAddPath(context, path);
            CGContextClip(context);
        }
    }
    UIColor *fillColor = components[@"fillColor"];
    if (fillColor) {
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillRect(context, rect);
    }
    UIImage *image = components[@"image"];
    [image pp_drawInRect:rect contentMode:UIViewContentModeScaleAspectFill withContext:context];
}

- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success
{
    if (!success) {
        return;
    }
    [self imageDrawingFinished];
}

- (void)imageDrawingFinished { }
@end
