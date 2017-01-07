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
        self.purposeType = 0;
        self.placeFlagImgOutside = NO;
    }
    return self;
}

- (void)setImageURL:(NSString *)imageURL
{
    [self setImageURL:imageURL placeholderImage:nil];
}

- (void)setImageURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage
{
    [self setImageURL:imageURL placeholderImage:placeholderImage localCacheFileAsyncFirst:YES];
}

- (void)setImageURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage localCacheFileAsyncFirst:(BOOL)localCacheFileAsyncFirst
{
    if (![_imageURL isEqualToString:imageURL]) {
        self.image = placeholderImage;
        [self cancelCurrentImageLoading];
        _imageURL = imageURL;
        [self loadImageWithPath:imageURL localCacheFileAsyncFirst:localCacheFileAsyncFirst];
    } else {
        
    }
}

- (void)loadImageWithPath:(NSString *)path localCacheFileAsyncFirst:(BOOL)localCacheFileAsyncFirst
{
    if (!path.length) {
        return;
    }
    
    void(^setImage)(UIImage *image) = ^(UIImage *image) {
        if (image) {
            [self setImageLoaderImage:image URL:path];
            if (_imageDidFinishLoadFromDiskBlock) {
                _imageDidFinishLoadFromDiskBlock();
            }
        } else {
            if (_imageLoadQueue) {
                [PPWebImageManager sharedManager].imageLoadQueue = _imageLoadQueue;
            } else {
                
            }
            [[PPWebImageManager sharedManager] loadImage:path delegate:self progress:^(NSUInteger receivedSize, NSUInteger expectedSize, NSString * _Nullable targetURL) {
                
            } complete:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                if (image) {
                    [self setImageLoaderImage:image URL:path];
                }
                if (_imageDidFinishDownloadBlock) {
                    _imageDidFinishDownloadBlock();
                }
            } autoCancel:YES options:0 cacheType:PPImageCacheTypeAll];
        }
    };
    UIImage *image = [[PPImageCache sharedCache] imageFromMemoryCacheForURL:path];
    setImage(image);
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
    self.reserveContentsBeforeNextDrawingComplete = YES;
    if (isGIf) {
        [self setGifImage:image];
    } else {
        [self setImage:image];
    }
}

- (void)cancelCurrentImageLoading
{
    [[PPWebImageManager sharedManager] cancelRequestForDelegate:self];
}
@end
