//
//  PPWebImageView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/19.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <PPAsyncDrawingKit/PPImageView.h>
#import <PPAsyncDrawingKit/PPImageDownloader.h>
#import <PPAsyncDrawingKit/PPImageCache.h>

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSUInteger, PPWebImageViewLoadState) {
//    PPWebImageViewLoadState,
//    PPWebImageViewLoadState,
//    PPWebImageViewLoadState,
//};

@interface PPWebImageView : PPImageView
@property (nonatomic, assign) int loadState;
@property (nonatomic, assign) BOOL allowPlayGif;
@property (nonatomic, assign) BOOL autoPlayGifIfReady;
@property (nonatomic, assign, readonly) BOOL imageLoaded;
@property (nonatomic, strong) NSURL *imageURL;


- (void)imageDrawingFinished;
- (void)cancelCurrentImageLoading;

- (void)setImageURL:(NSURL *)imageURL;
- (void)setImageURL:(NSURL *)imageURL placeholderImage:(nullable UIImage *)placeholderImage;
- (void)setImageURL:(NSURL *)imageURL placeholderImage:(nullable UIImage *)placeholderImage progressBlock:(nullable PPImageDownloaderProgress)progressBlock completeBlock:(nullable PPImageDownloaderCompletion)completeBlock;

- (void)setImageLoaderImage:(UIImage *)image URL:(NSURL *)URL;
- (void)setFinalImage:(UIImage *)image;
- (void)setFinalImage:(UIImage *)image isGIf:(BOOL)isGIf;
- (void)setGifImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
