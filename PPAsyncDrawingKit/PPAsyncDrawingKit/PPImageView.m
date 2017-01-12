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

static inline __nullable CGPathRef PPCreateRoundedCGPath(CGRect rect, CGFloat cornerRadius, UIRectCorner roundedCorners) {
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:cornerRadii];
    return CGPathCreateCopy(bezierPath.CGPath);
}

@interface PPImageView ()
@property (nonatomic, assign) CGPathRef roundPathRef;
@property (nonatomic, assign) CGPathRef borderPathRef;
@end

@implementation PPImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.roundedCorners = UIRectCornerAllCorners;
        self.showsCornerRadius = YES;
        self.showsBorderCornerRadius = YES;
        self.userInteractionEnabled = NO;
        self.borderWidth = 0.0f;
        self.clipsToBounds = YES;
        self.updatePathWhenViewSizeChanges = YES;
        self.isNeedChangeContentModel = NO;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        self.image = image;
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
    self.roundPathRef = nil;
    CGPathRelease(self.roundPathRef);
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = 0;
    self.roundPathRef = nil;
    CGPathRelease(self.roundPathRef);
    
    [self setNeedsDisplay];
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
            [self setNeedsDisplayAsync];
        }
    } else {
        _image = image;
        [self setNeedsDisplayAsync];
    }
}

- (void)displayLayer:(CALayer *)layer
{
    [super displayLayer:layer];
}

- (NSDictionary *)currentDrawingUserInfo
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo pp_setSafeObject:_image forKey:@"image"];
    if (self.showsCornerRadius) {
        CGPathRef path = PPCreateRoundedCGPath(self.bounds, self.cornerRadius, self.roundedCorners);
        [userInfo pp_setSafeObject:(__bridge id _Nonnull)(path) forKey:@"roundPath"];
        self.roundPathRef = path;
        CGPathRelease(path);
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
    
    UIImage *image = userInfo[@"image"];
    [image pp_drawInRect:rect contentMode:_contentMode withContext:context];
    
    CGPathRef path = (__bridge CGPathRef)(userInfo[@"roundPath"]);
    if (path) {
        CGContextAddPath(context, path);
        CGContextSetLineWidth(context, self.borderWidth);
        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
        CGContextStrokePath(context);
    }
    return YES;
}

- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success
{
    if (!success) {
        return;
    }
}

@end
