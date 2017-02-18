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
    BOOL _showsCornerRadius;
    BOOL _showsBorder;
}
@end

@implementation PPImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.roundedCorners = UIRectCornerAllCorners;
        self.userInteractionEnabled = NO;
        self.borderWidth = 0.0f;
        self.clipsToBounds = YES;
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
    _showsCornerRadius = cornerRadius > 0;
    self.layer.cornerRadius = 0;
    CGPathRelease(_roundPathRef);
    _roundPathRef = nil;
    
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (_borderWidth == borderWidth) {
        return;
    }
    
    _borderWidth = borderWidth;
    _showsBorder = borderWidth > 0;
    self.layer.borderWidth = 0.0f;
    CGPathRelease(_borderPathRef);
    _borderPathRef = nil;
    
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (_borderColor == borderColor) {
        return;
    }
    
    _borderColor = borderColor;
    self.layer.borderColor = nil;
    [self setNeedsDisplay];
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

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(self.frame, frame)) {
        [super setFrame:frame];
        [self setNeedsDisplay];
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (_image) {
        return _image.size;
    }
    return size;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously
{
    if (_showsCornerRadius) {
        CGPathRef path = _roundPathRef;
        if (!path) {
            path = PPCreateRoundedCGPath(self.bounds, self.cornerRadius, self.roundedCorners);
            _roundPathRef = path;
        }
        CGContextAddPath(context, path);
        CGContextClip(context);
    }
    
    UIImage *image = _image;
    if (image) {
        [image pp_drawInRect:rect contentMode:_contentMode withContext:context];
    }
    
    if (_showsBorder) {
        CGPathRef path = _borderPathRef;
        if (!path) {
            path = PPCreateRoundedCGPath(self.bounds, self.cornerRadius, self.roundedCorners);
            _borderPathRef = path;
        }
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
    _imageLoaded = NO;
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
    [self setFinalImage:image isGIf:image.images.count > 0];
    _imageLoaded = YES;
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
    [_displayLink invalidate];
    _displayLink = nil;
    CGPathRelease(_borderPathRef);
    CGPathRelease(_roundPathRef);
}
@end
