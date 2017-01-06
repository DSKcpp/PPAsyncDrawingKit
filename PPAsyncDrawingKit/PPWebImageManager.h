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

typedef void(^PPImageLoadCompleteBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error);
typedef void(^PPImageLoadProgressBlock)(NSUInteger receivedSize, NSUInteger expectedSize, NSString * _Nullable targetURL);

@interface PPWebImageManager : NSObject <PPImageLoadOperationDelegate, NSURLSessionDelegate>
@property (nonatomic, class, strong, readonly) PPWebImageManager *sharedManager;
@property (nonatomic, strong) dispatch_queue_t imageLoadQueue;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  complete:(PPImageLoadCompleteBlock)complete;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  progress:(nullable PPImageLoadProgressBlock)progress
                                  complete:(PPImageLoadCompleteBlock)complete;


- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id)delegate
                                  progress:(nullable PPImageLoadProgressBlock)progress
                                  complete:(PPImageLoadCompleteBlock)complete;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id)delegate
                                  progress:(nullable PPImageLoadProgressBlock)progress
                                  complete:(PPImageLoadCompleteBlock)complete
                                autoCancel:(BOOL)autoCancel;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id<PPImageLoadOperationDelegate>)delegate
                                  progress:(nullable PPImageLoadProgressBlock)progress
                                  complete:(PPImageLoadCompleteBlock)complete
                                 cacheType:(PPImageCacheType)cacheType;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id)delegate
                                  progress:(nullable PPImageLoadProgressBlock)progress
                                  complete:(PPImageLoadCompleteBlock)complete
                                autoCancel:(BOOL)autoCancel
                                   options:(long long)options
                                 cacheType:(PPImageCacheType)cacheType;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id)delegate
                                  progress:(nullable PPImageLoadProgressBlock)progress
                                  complete:(PPImageLoadCompleteBlock)complete
                                autoCancel:(BOOL)autoCancel
                                   options:(long long)options;

- (nullable PPImageLoadRequest *)loadImage:(NSString *)imageURL
                                  delegate:(nullable id)delegate
                                  progress:(PPImageLoadProgressBlock)progress
                                  complete:(PPImageLoadCompleteBlock)complete
                                autoCancel:(BOOL)autoCancel
                                 cacheType:(PPImageCacheType)cacheType;

- (nullable PPImageLoadOperation *)operationForURL:(NSString *)URL;

- (void)resumeImageLoad;
- (BOOL)imageLoadSuspended;
- (void)suspendImageLoad;
- (void)addRequest:(PPImageLoadRequest *)request;
- (void)cancelRequest:(PPImageLoadRequest *)request;
- (void)cancelRequestForDelegate:(id)delegate;
- (void)cancelRequestForURL:(NSString *)URL;
- (PPImageCache *)cache;
@end

NS_ASSUME_NONNULL_END
