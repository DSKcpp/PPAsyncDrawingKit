//
//  PPWebImageManager.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/24.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPImageLoadOperation.h"
#import "PPImageCache.h"

NS_ASSUME_NONNULL_BEGIN

@class PPImageLoadRequest;

typedef void(^PPWebImageDownloaderProgressBlock)(int64_t receivedSize, int64_t expectedSize, NSString * _Nullable targetURL);

typedef void(^PPExternalCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable imageURL);
typedef void(^PPInternalCompletionBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable imageURL);

@interface PPWebImageManager : NSObject <PPImageLoadOperationDelegate, NSURLSessionDelegate>
@property (nonatomic, class, strong, readonly) PPWebImageManager *sharedManager;
@property (nonatomic, strong) dispatch_queue_t imageLoadQueue;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  complete:(PPInternalCompletionBlock)complete;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  progress:(nullable PPWebImageDownloaderProgressBlock)progress
                                  complete:(PPInternalCompletionBlock)complete;


- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id)delegate
                                  progress:(nullable PPWebImageDownloaderProgressBlock)progress
                                  complete:(PPInternalCompletionBlock)complete;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id)delegate
                                  progress:(nullable PPWebImageDownloaderProgressBlock)progress
                                  complete:(PPInternalCompletionBlock)complete
                                autoCancel:(BOOL)autoCancel;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id<PPImageLoadOperationDelegate>)delegate
                                  progress:(nullable PPWebImageDownloaderProgressBlock)progress
                                  complete:(PPInternalCompletionBlock)complete
                                 cacheType:(PPImageCacheType)cacheType;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id)delegate
                                  progress:(nullable PPWebImageDownloaderProgressBlock)progress
                                  complete:(PPInternalCompletionBlock)complete
                                autoCancel:(BOOL)autoCancel
                                 cacheType:(PPImageCacheType)cacheType;

- (nullable PPImageLoadOperation *)operationForURL:(NSString *)URL;

- (void)addRequest:(PPImageLoadRequest *)request;
- (void)cancelRequest:(PPImageLoadRequest *)request;
- (void)cancelRequestForDelegate:(id)delegate;
- (void)cancelRequestForURL:(NSString *)URL;
- (BOOL)imageLoadSuspended;
- (void)resumeImageLoad;
- (void)suspendImageLoad;
- (PPImageCache *)cache;
@end

NS_ASSUME_NONNULL_END
