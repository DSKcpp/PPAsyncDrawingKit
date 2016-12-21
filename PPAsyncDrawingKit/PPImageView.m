//
//  PPImageView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/22.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageView.h"
#import "UIImage+PPAsyncDrawingKit.h"
#import "PPAsyncDrawingKitUtilities.h"

@implementation PPImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.roundedCorners = UIRectCornerAllCorners;
        self.showsCornerRadius = YES;
        self.showsBorderCornerRadius = YES;
        self.userInteractionEnabled = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        self.borderWidth = 0.0f;
        self.clipsToBounds = YES;
        self.updatePathWhenViewSizeChanges = YES;
        [self setDrawingPolicy:0];
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
        self.roundPathRef = CGPathRetain(roundPath);
        self.borderPathRef = CGPathRetain(borderPath);
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
    CGPathRelease(self.roundPathRef);
    self.roundPathRef = nil;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (cornerRadius <= 0) {
        CGPathRelease(self.roundPathRef);
        self.roundPathRef = nil;
        [self setNeedsDisplay];
    }
    self.layer.cornerRadius = cornerRadius;
}

- (void)setShowsBorderCornerRadius:(BOOL)showsBorderCornerRadius
{
    if (_showsBorderCornerRadius == showsBorderCornerRadius) {
        return;
    }
    _showsBorderCornerRadius = showsBorderCornerRadius;
    CGPathRelease(_borderPathRef);
    _borderPathRef = nil;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (_borderWidth != borderWidth) {
        _borderWidth = borderWidth;
        [self setNeedsDisplay];
    }
    self.layer.borderWidth = 0.0f;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (_borderColor != borderColor) {
        _borderColor = borderColor;
        [self setNeedsDisplay];
    }
    self.layer.borderColor = nil;
}

- (void)setImage:(UIImage *)image
{
    if (_image == image) {
        if (image == nil || self.layer.contents == nil) {
            self.contentsChangedAfterLastAsyncDrawing = YES;
            [self setNeedsDisplay];
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

- (void)displayLayer:(CALayer *)layer
{
    [super displayLayer:layer];
}

- (NSDictionary *)currentDrawingUserInfo
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo pp_setSafeObject:self.image forKey:@"image"];
    [userInfo pp_setSafeObject:self.fillColor forKey:@"fillColor"];
    if (self.showsCornerRadius) {
        CGPathRef path = CreateCGPath(self.bounds, self.cornerRadius, self.roundedCorners);
        _roundPathRef = path;
        [userInfo pp_setSafeObject:(__bridge id _Nonnull)(path) forKey:@"roundPath"];
    }
    if (self.showsBorderCornerRadius) {
        
    }
    return userInfo;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(NSDictionary *)userInfo
{
    if (self.showsCornerRadius) {
        CGPathRef path = (__bridge CGPathRef)(userInfo[@"roundPath"]);
        if (path) {
            CGContextAddPath(context, path);
            CGContextClip(context);
        }
    }
    UIColor *fillColor = userInfo[@"fillColor"];
    if (fillColor) {
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillRect(context, rect);
    }
    
//        if (self.showsBorderCornerRadius) {
//            if (path) {
//                CGContextAddPath(context, path);
//                CGContextSetLineWidth(context, self.borderWidth);
//                CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
//                CGContextStrokePath(context);
//            }
//        }
//    }


    UIImage *image = userInfo[@"image"];
    [image pp_drawInRect:rect contentMode:self.contentMode withContext:context];
    return YES;
}

- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success
{
    if (!success) {
        return;
    }
}

@end
