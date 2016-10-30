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

- (void)setImageUrl:(NSString *)imageUrl
{
    [self setImageUrl:imageUrl flagImageUrl:nil];
}

- (void)setImageUrl:(NSString *)url flagImageUrl:(id)arg2
{
    [self setImageUrl:url flagImageUrl:arg2 placeholderImage:nil];
}

- (void)setImageUrl:(NSString *)url flagImageUrl:(id)arg2 placeholderImage:(UIImage *)placeholderImage
{
    [self setImageUrl:url flagImageUrl:arg2 placeholderImage:placeholderImage localCacheFileAsyncFirst:YES];
}

- (void)setImageUrl:(NSString *)url flagImageUrl:(id)arg2 placeholderImage:(UIImage *)placeholderImage localCacheFileAsyncFirst:(BOOL)arg4
{
    if ([_imageUrl isEqualToString:url]) {
        
    } else {
        
    }
}

- (void)setImageUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    [self setImageUrl:url flagImageUrl:nil placeholderImage:placeholderImage];
}

- (void)loadImageWithPath:(id)arg1 localCacheFileAsyncFirst:(BOOL)arg2
{
    
}

@end
