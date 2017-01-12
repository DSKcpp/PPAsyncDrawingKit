//
//  PPWebImageView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/19.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageView.h"
#import "PPWebImageManager.h"

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSUInteger, PPWebImageViewLoadState) {
//    PPWebImageViewLoadState,
//    PPWebImageViewLoadState,
//    PPWebImageViewLoadState,
//};

@interface PPWebImageView : PPImageView
@property (nonatomic, assign) int loadState;
@property (nonatomic, assign) dispatch_queue_t imageLoadQueue;
@property (nonatomic, assign) BOOL allowPlayGif;
@property (nonatomic, assign) BOOL autoPlayGifIfReady;
@property (nonatomic, assign, readonly) BOOL imageLoaded;
@property (nonatomic, copy) NSString *imageURL;


- (void)imageDrawingFinished;
- (void)cancelCurrentImageLoading;

- (void)setImageURL:(NSString *)imageURL;
- (void)setImageURL:(NSString *)imageURL placeholderImage:(nullable UIImage *)placeholderImage;
- (void)setImageURL:(NSString *)imageURL placeholderImage:(nullable UIImage *)placeholderImage progressBlock:(nullable PPWebImageDownloaderProgressBlock)progressBlock completeBlock:(nullable PPExternalCompletionBlock)completeBlock;

- (void)setImageLoaderImage:(UIImage *)image URL:(NSString *)URL;
- (void)setFinalImage:(UIImage *)image;
- (void)setFinalImage:(UIImage *)image isGIf:(BOOL)isGIf;
- (void)setGifImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
