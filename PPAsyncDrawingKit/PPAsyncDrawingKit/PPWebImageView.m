//
//  PPWebImageView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/19.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPWebImageView.h"
#import "PPAssert.h"

@interface PPWebImageView ()
{
    PPImageDownloaderTask *_task;
}
@end

@implementation PPWebImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoPlayGifIfReady = NO;
        self.allowPlayGif = NO;
    }
    return self;
}

- (void)dealloc
{
    [self cancelCurrentImageLoading];
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
        [[PPImageCache sharedCache] imageForURL:imageURL.absoluteString callback:^(UIImage * _Nullable image, PPImageCacheType cacheType) {
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
                    _task = task;
                }
            }
        }];
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
    [self setFinalImage:image isGIf:NO];
}

- (void)setFinalImage:(UIImage *)image isGIf:(BOOL)isGIf
{
    self.clearsContextBeforeDrawing = NO;
    if (isGIf) {
        [self setGifImage:image];
    } else {
        [self setImage:image];
    }
}

- (void)imageDrawingFinished
{
    
}

- (void)cancelCurrentImageLoading
{
    if (_task) {
        [[PPImageDownloader sharedImageDownloader] cancelImageDownloaderWithTask:_task];
    }
    _task = nil;
}
@end
