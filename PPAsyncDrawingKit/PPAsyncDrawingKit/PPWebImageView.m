//
//  PPWebImageView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/19.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPWebImageView.h"

@implementation PPWebImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoPlayGifIfReady = NO;
        self.allowPlayGif = NO;
    }
    return self;
}

- (void)setImageURL:(NSString *)imageURL
{
    [self setImageURL:imageURL placeholderImage:nil];
}

- (void)setImageURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage
{

    [self setImageURL:imageURL placeholderImage:placeholderImage progressBlock:nil completeBlock:nil];
}

- (void)setImageURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage progressBlock:(PPWebImageDownloaderProgressBlock)progressBlock completeBlock:(PPExternalCompletionBlock)completeBlock
{
    [self cancelCurrentImageLoading];
    self.image = placeholderImage;
    
    if (imageURL) {
        _imageURL = imageURL;
         UIImage *image = [[PPImageCache sharedCache] imageFromMemoryCacheForURL:imageURL];
        if (image) {
            [self setImageLoaderImage:image URL:imageURL];
            if (completeBlock) {
                completeBlock(image, nil, imageURL);
            }
        } else {
            if (_imageLoadQueue) {
                [PPWebImageManager sharedManager].imageLoadQueue = _imageLoadQueue;
            }
            [[PPWebImageManager sharedManager] loadImage:imageURL delegate:self progress:progressBlock complete:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable imageURL) {
                if (image) {
                    [self setImageLoaderImage:image URL:imageURL];
                }
                if (completeBlock) {
                    completeBlock(image, error, imageURL);
                }
            } autoCancel:YES cacheType:PPImageCacheTypeAll];
        }
    } else {
        NSError *error;
        if (completeBlock) {
            completeBlock(nil, error, imageURL);
        }
    }
}

- (void)setImageLoaderImage:(UIImage *)image URL:(NSString *)URL
{
    if ([self.imageURL isEqualToString:URL]) {
        [self setFinalImage:image];
    }
}

- (void)setFinalImage:(UIImage *)image
{
//    if (self.imageURL) {
//        
//    }
    [self setFinalImage:image isGIf:NO];
}

- (void)setFinalImage:(UIImage *)image isGIf:(BOOL)isGIf
{
    self.reservePreviousContents = YES;
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
    [[PPWebImageManager sharedManager] cancelRequestForDelegate:self];
}
@end
