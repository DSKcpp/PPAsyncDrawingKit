//
//  PPWebImageView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/19.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPWebImageView.h"
#import "PPAssert.h"

@implementation PPWebImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoPlayGifIfReady = NO;
        self.allowPlayGif = NO;
    }
    return self;
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
    PPASDKAssert(imageURL, @"image download URL not nil");
    
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
                [[PPImageDownloader sharedImageDownloader] downloaderImageWithURL:imageURL downloadProgress:^(CGFloat progress) {
                    NSLog(@"%f", progress);
                } completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    if (image) {
                        [self setImageLoaderImage:image URL:imageURL];
                    } else {
                        NSLog(@"%@", error);
                    }
                }];
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
    
}
@end
