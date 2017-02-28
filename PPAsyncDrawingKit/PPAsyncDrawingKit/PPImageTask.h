//
//  PPImageTask.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/3/1.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PPImageTask <NSObject>

/**
 图片URL
 */
@property (nonatomic, strong, readonly) NSString *URL;

/**
 根据URL从队列中获取任务，如果队列中没有，将创建一个新的任务
 
 @param URL 文件URL
 @return 任务
 */
+ (id<PPImageTask>)taskForURL:(NSString *)URL;

/**
 根据URL创建任务

 @param URL 图片URL
 @return 任务
 */
- (id<PPImageTask>)initWithURL:(NSString *)URL;

/**
 是否需要取消任务
 
 @return YES 的话就取消IO任务
 */
- (BOOL)isCancelled;

/**
 取消任务
 */
- (void)cancel;
@end

#pragma mark - IO Task
@interface PPImageIOTask : NSObject <PPImageTask> @end

#pragma mark - Downloader Task
typedef void (^PPImageDownloaderProgress)(CGFloat progress);

typedef void(^PPImageDownloaderCompletion)(UIImage * _Nullable image, NSError * _Nullable error);

@interface PPImageDownloaderTask : NSObject <PPImageTask>
@property (nullable, nonatomic, copy) PPImageDownloaderProgress downloadProgress;
@property (nonatomic, copy) PPImageDownloaderCompletion completion;
@property (nonatomic, strong) NSURLSessionDownloadTask *sessionDownloadTask;

- (nullable NSURLSessionDownloadTask *)createSessionTaskIfNecessaryWithBlock:(NSURLSessionDownloadTask *(^)())creationBlock;
@end

NS_ASSUME_NONNULL_END

