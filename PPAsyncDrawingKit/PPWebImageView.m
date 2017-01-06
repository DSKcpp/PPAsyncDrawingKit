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
    }
}

- (void)loadImageWithPath:(NSString *)path localCacheFileAsyncFirst:(BOOL)localCacheFileAsyncFirst
{
    [[PPWebImageManager sharedManager] loadImage:path delegate:self progress:^(NSUInteger receivedSize, NSUInteger expectedSize, NSString * _Nullable targetURL) {
        float progress = receivedSize / expectedSize;
        NSLog(@"%f", progress);
    } complete:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
        if (image) {
            self.image = image;
        }
    } autoCancel:YES options:0 cacheType:PPImageCacheTypeAll];

}

- (void)cancelCurrentImageLoading
{
    [[PPWebImageManager sharedManager] cancelRequestForDelegate:self];
}
@end
