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
@property (nonatomic, strong, readonly) NSString *URL;
@property (nullable, nonatomic, copy) PPImageDownloaderProgress downloadProgress;
@property (nonatomic, copy) PPImageDownloaderCompletion completion;
@property (nonatomic, strong) NSURLSessionDownloadTask *sessionDownloadTask;

+ (PPImageDownloaderTask *)taskForURL:(NSString *)URL;
- (instancetype)initWithURL:(NSString *)URL;
- (BOOL)isCancelled;
- (void)cancel;
- (nullable NSURLSessionDownloadTask *)createSessionTaskIfNecessaryWithBlock:(NSURLSessionDownloadTask *(^)())creationBlock;
@end

@interface PPImageDownloader : NSObject
@property (nonatomic, class, strong, readonly) PPImageDownloader *sharedImageDownloader;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, PPImageDownloaderTask *> *downloaderTasks;

- (PPImageDownloaderTask *)downloaderImageWithURL:(NSURL *)URL
                                 downloadProgress:(nullable PPImageDownloaderProgress)downloadProgress
                                       completion:(PPImageDownloaderCompletion)completion;

- (PPImageDownloaderTask *)fetchDownloaderTaskWithURL:(NSString *)URL;
- (void)cancelImageDownloaderWithTask:(PPImageDownloaderTask *)downloaderTask;
@end

NS_ASSUME_NONNULL_END
