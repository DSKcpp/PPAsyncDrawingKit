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

typedef void(^PPWebImageBlock)(void);

@interface PPWebImageView : PPImageView
@property (nonatomic, strong) UIImageView *livePhotoImageView;
@property (nonatomic, copy) NSString *currentReadingTaskKey;
@property (nonatomic, assign) int loadState;
@property (nonatomic, assign) BOOL usesSyncLoad;
@property (nonatomic, assign) dispatch_queue_t imageLoadQueue;
@property (nonatomic, assign) BOOL placeFlagImgOutside;
@property (nonatomic, assign) BOOL clearsLayerContentsWhenViewDisappear;
@property (nonatomic, assign) long long purposeType;
@property (nonatomic, assign) BOOL allowPlayGif;
@property (nonatomic, assign) BOOL autoPlayGifIfReady;
@property (nonatomic, assign) BOOL showDownloadProgress;
@property (nonatomic, strong) UIImage *failedPlaceholder;
@property (nonatomic, assign) BOOL imageChangedAfterFadeinAnimation;
@property (nonatomic, strong, readonly) NSString *flagImageUrl;
@property (nonatomic, assign) BOOL isAnimationWhenFinalImageReceived;
@property (copy, nonatomic) PPWebImageBlock imageDidFinishSaveToDiskBlock;
@property (copy, nonatomic) PPWebImageBlock imageDidBeginDownloadBlock;
@property (copy, nonatomic) PPWebImageBlock imageDidFinishLoadFromDiskBlock;
@property (copy, nonatomic) PPWebImageBlock imageDidFinishDownloadBlock;
@property (copy, nonatomic) PPWebImageBlock buildAlternativeImageUrlsBlock;
@property (nonatomic, assign) BOOL ignoreImageMask;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign, readonly) BOOL imageLoaded;

- (void)imageDrawingFinished;
- (void)cancelCurrentImageLoading;

- (void)loadImageWithPath:(NSString *)path;

- (void)setImageURL:(NSString *)imageURL;
- (void)setImageURL:(NSString *)imageURL placeholderImage:(nullable UIImage *)placeholderImage;

- (void)setImageLoaderImage:(UIImage *)image URL:(NSString *)URL;
- (void)setFinalImage:(UIImage *)image;
- (void)setFinalImage:(UIImage *)image isGIf:(BOOL)isGIf;
- (void)setGifImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
