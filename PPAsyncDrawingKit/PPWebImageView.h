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
@property (copy, nonatomic) id imageDidFinishSaveToDiskBlock;
@property (copy, nonatomic) id imageDidBeginDownloadBlock;
@property (copy, nonatomic) id imageDidFinishLoadFromDiskBlock;
@property (copy, nonatomic) id imageDidFinishDownloadBlock;
@property (copy, nonatomic) id buildAlternativeImageUrlsBlock;
@property (nonatomic, assign) BOOL ignoreImageMask;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign, readonly) BOOL imageLoaded;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (void)imageDrawingFinished;
- (void)setFinalFlagImage:(id)arg1;
- (void)setFinalImage:(id)arg1;
- (void)changePlaceholderImage:(id)arg1;
- (void)cancelCurrentImageLoading;
- (void)setContentMode:(long long)arg1;
- (void)setGifImage:(id)arg1;
- (void)setFrame:(CGRect)frame;

- (void)loadImageWithPath:(NSString *)path localCacheFileAsyncFirst:(BOOL)localCacheFileAsyncFirst;

- (void)setImageURL:(NSString *)imageURL;
- (void)setImageURL:(NSString *)imageURL placeholderImage:(nullable UIImage *)placeholderImage;
- (void)setImageURL:(NSString *)imageURL placeholderImage:(nullable UIImage *)placeholderImage localCacheFileAsyncFirst:(BOOL)localCacheFileAsyncFirst;

- (void)offsetFlagImageViewPos:(CGSize)arg1;
- (void)resetMaskColor;
- (void)setBorderWidth:(CGFloat)borderWidth;
- (void)markAsLoaded;
- (BOOL)hiddenFlagImageView;
- (void)setHiddenFlagImageView:(BOOL)arg1;
- (BOOL)redrawsAutomaticallyWhenStateChange;
- (void)setHighlighted:(BOOL)highlighted;
@end

@interface PPWebImageView (LoadImage)
- (void)loadImageWithImageUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;
@end

@interface PPWebImageView (PPRoundRectImage)
- (void)pp_setRoundRectImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder cropSize:(CGSize)cropSize;
@end

NS_ASSUME_NONNULL_END
