//
//  AsyncImageView.swift
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/3.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncImageView: AsyncUIControl {

    var image: UIImage?
    
    lazy var lock = Lock()
    
    lazy var roundedCorners: UIRectCorner = .allCorners
    lazy var borderWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
    
//    - (instancetype)initWithFrame:(CGRect)frame
//    {
//    if (self = [super initWithFrame:frame]) {
//    _lock = [[PPLock alloc] init];
//    self.roundedCorners = UIRectCornerAllCorners;
//    self.userInteractionEnabled = NO;
//    self.borderWidth = 0.0f;
//    self.clipsToBounds = YES;
//    }
//    return self;
//    }
//    
//    - (instancetype)initWithImage:(UIImage *)image
//    {
//    if (self = [super init]) {
//    self.image = image;
//    }
//    return self;
//    }
//    
//    - (instancetype)initWithCornerRadius:(CGFloat)cornerRadius
//    {
//    return [self initWithCornerRadius:cornerRadius byRoundingCorners:UIRectCornerAllCorners];
//    }
//    
//    - (instancetype)initWithCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)roundingCorners
//    {
//    if (self = [self init]) {
//    self.cornerRadius = cornerRadius;
//    self.roundedCorners = roundingCorners;
//    }
//    return self;
//    }
//    
//    - (CGPathRef)roundPathRef
//    {
//    [_lock lock];
//    CGPathRef path = _roundPathRef;
//    [_lock unlock];
//    return path;
//    }
//    
//    - (void)setRoundPathRef:(CGPathRef)roundPathRef
//    {
//    if (self.roundPathRef == roundPathRef) {
//    return;
//    }
//    [_lock lock];
//    CGPathRelease(_roundPathRef);
//    _roundPathRef = CGPathRetain(roundPathRef);
//    [_lock unlock];
//    }
//    
//    - (CGPathRef)borderPathRef
//    {
//    [_lock lock];
//    CGPathRef path = _borderPathRef;
//    [_lock unlock];
//    return path;
//    }
//    
//    - (void)setBorderPathRef:(CGPathRef)borderPathRef
//    {
//    if (self.borderPathRef == borderPathRef) {
//    return;
//    }
//    [_lock lock];
//    CGPathRelease(_borderPathRef);
//    _borderPathRef = CGPathRetain(borderPathRef);
//    [_lock unlock];
//    }
//    
//    - (void)setRoundedCorners:(UIRectCorner)roundedCorners
//    {
//    if (_roundedCorners == roundedCorners) {
//    return;
//    }
//    _roundedCorners = roundedCorners;
//    self.roundPathRef = nil;
//    [self setNeedsDisplay];
//    }
//    
//    - (void)setCornerRadius:(CGFloat)cornerRadius
//    {
//    if (_cornerRadius == cornerRadius) {
//    return;
//    }
//    _cornerRadius = cornerRadius;
//    _showsCornerRadius = cornerRadius > 0;
//    self.layer.cornerRadius = 0;
//    self.roundPathRef = nil;
//    
//    [self setNeedsDisplay];
//    }
//    
//    - (void)setBorderWidth:(CGFloat)borderWidth
//    {
//    if (_borderWidth == borderWidth) {
//    return;
//    }
//    
//    _borderWidth = borderWidth;
//    _showsBorder = borderWidth > 0;
//    self.layer.borderWidth = 0.0f;
//    self.borderPathRef = nil;
//    
//    [self setNeedsDisplay];
//    }
//    
//    - (void)setBorderColor:(UIColor *)borderColor
//    {
//    if (_borderColor == borderColor) {
//    return;
//    }
//    
//    _borderColor = borderColor;
//    self.layer.borderColor = nil;
//    [self setNeedsDisplay];
//    }
//    
//    - (UIImage *)image
//    {
//    [_lock lock];
//    UIImage *image = _image;
//    [_lock unlock];
//    return image;
//    }
//    
//    - (void)setImage:(UIImage *)image
//    {
//    if (self.image == image) {
//    if (image == nil || self.layer.contents == nil) {
//    [self setNeedsDisplay];
//    }
//    } else {
//    [_lock lock];
//    _image = image;
//    [_lock unlock];
//    [self setNeedsDisplay];
//    }
//    }
//    
//    - (void)setFrame:(CGRect)frame
//    {
//    if (!CGRectEqualToRect(self.frame, frame)) {
//    [super setFrame:frame];
//    self.roundPathRef = nil;
//    self.borderPathRef = nil;
//    [self setNeedsDisplay];
//    }
//    }
//    
//    - (CGSize)sizeThatFits:(CGSize)size
//    {
//    UIImage *image = self.image;
//    if (image) {
//    return image.size;
//    }
//    return size;
//    }
//    
//    - (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously
//    {
//    if (_showsCornerRadius) {
//    CGPathRef path = self.roundPathRef;
//    if (!path) {
//    path = PPCreateRoundedCGPath(self.bounds, self.cornerRadius, self.roundedCorners);
//    self.roundPathRef = path;
//    }
//    CGContextAddPath(context, path);
//    CGContextClip(context);
//    }
//    
//    UIImage *image = self.image;
//    if (image) {
//    [image pp_drawInRect:rect contentMode:_contentMode withContext:context];
//    }
//    
//    if (_showsBorder) {
//    CGPathRef path = self.borderPathRef;
//    if (!path) {
//    path = PPCreateRoundedCGPath(self.bounds, self.cornerRadius, self.roundedCorners);
//    self.borderPathRef = path;
//    }
//    CGContextAddPath(context, path);
//    CGContextSetLineWidth(context, self.borderWidth);
//    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
//    CGContextStrokePath(context);
//    }
//    return YES;
//    }
//    
//    - (void)startAnimating
//    {
//    _currentAnimationImageIndex = 0;
//    if (!_displayLink) {
//    _displayLink = [CADisplayLink displayLinkWithTarget:[PPWeakProxy weakProxyWithTarget:self] selector:@selector(setAnimationImage:)];
//    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    }
//    _displayLink.frameInterval = 2;
//    _displayLink.paused = NO;
//    }
//    
//    - (void)stopAnimating
//    {
//    _displayLink.paused = YES;
//    }
//    
//    - (void)setAnimationImage:(CADisplayLink *)displayLink
//    {
//    if (self.image.images.count > 0) {
//    UIImage *image = self.image.images[_currentAnimationImageIndex];
//    self.layer.contents = (__bridge id _Nullable)(image.CGImage);
//    _currentAnimationImageIndex += 1;
//    if (_currentAnimationImageIndex == self.image.images.count) {
//    _currentAnimationImageIndex = 0;
//    }
//    }
//    }
//    
//    - (void)setImageURL:(NSURL *)imageURL
//    {
//    [self setImageURL:imageURL placeholderImage:nil];
//    }
//    
//    - (void)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage
//    {
//    [self setImageURL:imageURL placeholderImage:placeholderImage progressBlock:nil completeBlock:nil];
//    }
//    
//    - (void)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage progressBlock:(PPImageDownloaderProgress)progressBlock completeBlock:(PPImageDownloaderCompletion)completeBlock
//    {
//    if (!imageURL || _imageURL == imageURL) {
//    return;
//    }
//    
//    [self cancelCurrentImageLoading];
//    
//    _imageURL = imageURL;
//    _imageLoaded = NO;
//    self.image = placeholderImage;
//    
//    if (imageURL.isFileURL) {
//    UIImage *image = [UIImage imageWithContentsOfFile:imageURL.path];
//    if (image) {
//    [self setFinalImage:image];
//    }
//    } else {
//    PPImageIOTask *ioTask = [[PPImageCache sharedCache] imageForURL:imageURL.absoluteString callback:^(UIImage * _Nullable image, PPImageCacheType cacheType) {
//    if (image) {
//    [self setImageLoaderImage:image URL:imageURL];
//    } else {
//    PPImageDownloaderTask *task =[[PPImageDownloader sharedImageDownloader] downloaderImageWithURL:imageURL downloadProgress:^(CGFloat progress) {
//    if (progressBlock) progressBlock(progress);
//    } completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
//    if (image) {
//    [self setImageLoaderImage:image URL:imageURL];
//    } else if (error) {
//    NSLog(@"%@", error);
//    }
//    }];
//    if ([_imageURL isEqual:imageURL]) {
//    _downloadTask = task;
//    }
//    }
//    }];
//    _ioTask = ioTask;
//    }
//    }
//    
//    - (void)setImageLoaderImage:(UIImage *)image URL:(NSURL *)URL
//    {
//    if ([_imageURL.absoluteString isEqualToString:URL.absoluteString]) {
//    [self setFinalImage:image];
//    }
//    }
//    - (void)setFinalImage:(UIImage *)image
//    {
//    [self setFinalImage:image isGIf:image.images.count > 0];
//    _imageLoaded = YES;
//    }
//    
//    - (void)setFinalImage:(UIImage *)image isGIf:(BOOL)isGIf
//    {
//    [self stopAnimating];
//    self.clearsContextBeforeDrawing = NO;
//    if (isGIf) {
//    [self setGifImage:image];
//    } else {
//    [self setImage:image];
//    }
//    }
//    
//    - (void)setGifImage:(UIImage *)image
//    {
//    [self setImage:image];
//    [self startAnimating];
//    }
//    
//    - (void)imageDrawingFinished
//    {
//    
//    }
//    
//    - (void)cancelCurrentImageLoading
//    {
//    if (_downloadTask) {
//    [[PPImageDownloader sharedImageDownloader] cancelImageDownloaderWithTask:_downloadTask];
//    _downloadTask = nil;
//    }
//    
//    if (_ioTask) {
//    [[PPImageCache sharedCache] cancelImageIOWithTask:_ioTask];
//    _ioTask = nil;
//    }
//    }
//    
//    - (void)dealloc
//    {
//    [self cancelCurrentImageLoading];
//    [self stopAnimating];
//    [_displayLink invalidate];
//    CGPathRelease(_borderPathRef);
//    CGPathRelease(_roundPathRef);
//    }
