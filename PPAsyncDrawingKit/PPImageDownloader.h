//
//  PPImageDownloader.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/17.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PPImageDownloaderProgress)(CGFloat progress);

typedef void(^PPImageDownloaderCompletion)(UIImage * _Nullable image, NSError * _Nullable error);

@interface PPImageDownloaderTask : NSObject
@property (nonatomic, strong, readonly) NSURL *URL;
@property (nullable, nonatomic, copy) PPImageDownloaderProgress downloadProgress;
@property (nonatomic, copy) PPImageDownloaderCompletion completion;

+ (PPImageDownloaderTask *)taskForURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL;
- (void)setSessionDownloadTask:(NSURLSessionDownloadTask *)sessionDownloadTask;
- (BOOL)isCancelled;
- (void)cancel;
@end

@interface PPImageDownloader : NSObject
@property (nonatomic, class, strong, readonly) PPImageDownloader *sharedImageDownloader;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, PPImageDownloaderTask *> *downloaderTasks;

- (PPImageDownloaderTask *)downloaderImageWithURL:(NSURL *)URL
                                 downloadProgress:(nullable PPImageDownloaderProgress)downloadProgress
                                       completion:(PPImageDownloaderCompletion)completion;

- (void)cancelImageDownloaderWithTask:(PPImageDownloaderTask *)downloaderTask;
@end

NS_ASSUME_NONNULL_END
