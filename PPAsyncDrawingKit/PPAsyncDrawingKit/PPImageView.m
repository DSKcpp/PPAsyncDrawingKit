//
//  PPImageView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/22.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageView.h"
#import "UIImage+PPAsyncDrawingKit.h"
#import "PPWeakProxy.h"

NSString * const PPImageViewRoundPath = @"PPImageViewRoundPath";
NSString * const PPImageViewBorderPath = @"PPImageViewBorderPath";

static inline __nullable CGPathRef PPCreateRoundedCGPath(CGRect rect, CGFloat cornerRadius, UIRectCorner roundedCorners) {
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:cornerRadii];
    return CGPathCreateCopy(bezierPath.CGPath);
}

@interface PPImageView ()
{
    CGPathRef _roundPathRef;
    CGPathRef _borderPathRef;
    CADisplayLink *_displayLink;
    PPImageDownloaderTask *_downloadTask;
    PPImageIOTask *_ioTask;
}
@end

@implementation PPImageView
@synthesize animationDuration = _animationDuration;
@synthesize currentAnimationImageIndex = _currentAnimationImageIndex;

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
    _roundPathRef = nil;
    CGPathRelease(_roundPathRef);
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = 0;
    _roundPathRef = nil;
    CGPathRelease(_roundPathRef);
    
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
            [self setNeedsDisplay];
        }
    } else {
        _image = image;
        [self setNeedsDisplay];
    }
}

- (NSDictionary *)currentDrawingUserInfo
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (self.showsCornerRadius) {
        CGPathRef path = PPCreateRoundedCGPath(self.bounds, self.cornerRadius, self.roundedCorners);
        if (path) {
            [userInfo setObject:(__bridge id _Nonnull)(path) forKey:PPImageViewRoundPath];
        }
        _roundPathRef = path;
        CGPathRelease(path);
    }
    if (self.showsBorderCornerRadius) {

    }
    return userInfo;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously
{
    NSDictionary *userInfo = self.currentDrawingUserInfo;
    if (self.showsCornerRadius) {
        CGPathRef path = (__bridge CGPathRef)(userInfo[PPImageViewRoundPath]);
        if (path) {
            CGContextAddPath(context, path);
            CGContextClip(context);
        }
    }
    
    UIImage *image = _image;
    if (image) {
        [image pp_drawInRect:rect contentMode:_contentMode withContext:context];
    }
    
    CGPathRef path = (__bridge CGPathRef)(userInfo[PPImageViewRoundPath]);
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

- (void)startAnimating
{
    _currentAnimationImageIndex = 0;
    _displayLink = [CADisplayLink displayLinkWithTarget:[PPWeakProxy weakProxyWithTarget:self] selector:@selector(setAnimationImage:)];
    _displayLink.frameInterval = 2;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimating
{
    _displayLink.paused = YES;
}

- (void)setAnimationImage:(CADisplayLink *)displayLink
{
    if (self.image.images.count > 0) {
        UIImage *image = self.image.images[_currentAnimationImageIndex];
        self.layer.contents = (__bridge id _Nullable)(image.CGImage);
        _currentAnimationImageIndex += 1;
        if (_currentAnimationImageIndex == self.image.images.count) {
            _currentAnimationImageIndex = 0;
        }
    }
}

- (void)setImageURL:(NSURL *)imageURL
{
    [self setImageURL:imageURL placeholderImage:nil];
}

- (void)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage
{
    [self setImageURL:imageURL placeholderImage:placeholderImage progressBlock:nil completeBlock:nil];
}

- (void)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage progressBlock:(PPImageDownloaderProgress)progressBlock completeBlock:(PPImageDownloaderCompletion)completeBlock
{
    if (!imageURL || _imageURL == imageURL) {
        return;
    }
    
    [self cancelCurrentImageLoading];
    
    _imageURL = imageURL;
    self.image = placeholderImage;
    
    if (imageURL.isFileURL) {
        UIImage *image = [UIImage imageWithContentsOfFile:imageURL.path];
        if (image) {
            [self setFinalImage:image];
        }
    } else {
        PPImageIOTask *ioTask = [[PPImageCache sharedCache] imageForURL:imageURL.absoluteString callback:^(UIImage * _Nullable image, PPImageCacheType cacheType) {
            if (image) {
                [self setImageLoaderImage:image URL:imageURL];
            } else {
                PPImageDownloaderTask *task =[[PPImageDownloader sharedImageDownloader] downloaderImageWithURL:imageURL downloadProgress:^(CGFloat progress) {
                    if (progressBlock) progressBlock(progress);
                } completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    if (image) {
                        [self setImageLoaderImage:image URL:imageURL];
                    } else {
                        NSLog(@"%@", error);
                    }
                }];
                if ([_imageURL isEqual:imageURL]) {
                    _downloadTask = task;
                }
            }
        }];
        _ioTask = ioTask;
        
    }
}

- (void)setImageLoaderImage:(UIImage *)image URL:(NSURL *)URL
{
    if ([_imageURL.absoluteString isEqualToString:URL.absoluteString]) {
        [self setFinalImage:image];
    }
}
- (void)setFinalImage:(UIImage *)image
{
    [self setFinalImage:image isGIf:image.images.count];
}

- (void)setFinalImage:(UIImage *)image isGIf:(BOOL)isGIf
{
    [self stopAnimating];
    self.clearsContextBeforeDrawing = NO;
    if (isGIf) {
        [self setGifImage:image];
    } else {
        [self setImage:image];
    }
}

- (void)setGifImage:(UIImage *)image
{
    [self setImage:image];
    [self startAnimating];
}

- (void)imageDrawingFinished
{
    
}

- (void)cancelCurrentImageLoading
{
    if (_downloadTask) {
        [[PPImageDownloader sharedImageDownloader] cancelImageDownloaderWithTask:_downloadTask];
        _downloadTask = nil;
    }
    
    if (_ioTask) {
        [[PPImageCache sharedCache] cancelImageIOWithTask:_ioTask];
        _ioTask = nil;
    }
}

- (void)dealloc
{
    [self cancelCurrentImageLoading];
    [self stopAnimating];
    _displayLink = nil;
}
@end
