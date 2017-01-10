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
    if (![_imageURL isEqualToString:imageURL]) {
        self.image = placeholderImage;
        [self cancelCurrentImageLoading];
        _imageURL = imageURL;
        [self loadImageWithPath:imageURL];
    } else {
        
    }
}

- (void)loadImageWithPath:(NSString *)path
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
            [[PPWebImageManager sharedManager] loadImage:path delegate:self progress:^(int64_t receivedSize, int64_t expectedSize, NSString * _Nullable targetURL) {
                
            } complete:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                if (image) {
                    [self setImageLoaderImage:image URL:path];
                }
                if (_imageDidFinishDownloadBlock) {
                    _imageDidFinishDownloadBlock();
                }
            } autoCancel:YES cacheType:PPImageCacheTypeAll];
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

- (void)imageDrawingFinished
{
    
}

- (void)cancelCurrentImageLoading
{
    [[PPWebImageManager sharedManager] cancelRequestForDelegate:self];
}
@end
