//
//  PPImageView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/22.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPControl.h"
#import <PPAsyncDrawingKit/PPImageDownloader.h>
#import <PPAsyncDrawingKit/PPImageCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPImageView : PPControl
@property (nullable, nonatomic, strong) UIImage *image;
@property (nullable, nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIRectCorner roundedCorners;
@property (nonatomic, assign) UIViewContentMode contentMode;

@property (nonatomic, assign, readonly) BOOL imageLoaded;
@property (nonatomic, strong) NSURL *imageURL;

@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign, readonly) NSUInteger currentAnimationImageIndex;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithCornerRadius:(CGFloat)cornerRadius;
- (instancetype)initWithCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)roundingCorners;

- (void)imageDrawingFinished;
- (void)cancelCurrentImageLoading;

- (void)setImageURL:(nullable NSURL *)imageURL;
- (void)setImageURL:(nullable NSURL *)imageURL placeholderImage:(nullable UIImage *)placeholderImage;
- (void)setImageURL:(nullable NSURL *)imageURL placeholderImage:(nullable UIImage *)placeholderImage progressBlock:(nullable PPImageDownloaderProgress)progressBlock completeBlock:(nullable PPImageDownloaderCompletion)completeBlock;

- (void)setImageLoaderImage:(UIImage *)image URL:(NSURL *)URL;
- (void)setFinalImage:(UIImage *)image;
- (void)setFinalImage:(UIImage *)image isGIf:(BOOL)isGIf;

- (void)startAnimating;
- (void)stopAnimating;
@end

NS_ASSUME_NONNULL_END
