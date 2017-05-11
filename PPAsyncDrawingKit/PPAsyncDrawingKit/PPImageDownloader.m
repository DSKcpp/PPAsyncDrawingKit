//
//  PPImageDownloader.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/17.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPImageDownloader.h"
#import "PPImageDecode.h"
#import "PPImageCache.h"
#import "PPLock.h"
#import "PPDefines.h"

@interface PPImageDownloader () <NSURLSessionDownloadDelegate>
{
    NSOperationQueue *_sessionDelegateQueue;
    PPLock *_lock;
}
@end

@implementation PPImageDownloader
+ (PPImageDownloader *)sharedImageDownloader
{
    static PPImageDownloader *sharedImageDownloader;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedImageDownloader = [[PPImageDownloader alloc] init];
    });
    return sharedImageDownloader;
}

- (instancetype)init
{
    if (self = [super init]) {
        _lock = [[PPLock alloc] init];
        _sessionDelegateQueue = [[NSOperationQueue alloc] init];
        _sessionDelegateQueue.maxConcurrentOperationCount = 10;
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:_sessionDelegateQueue];
        _downloaderTasks = @{}.mutableCopy;
    }
    return self;
}

- (PPImageDownloaderTask *)downloaderImageWithURL:(NSURL *)URL downloadProgress:(PPImageDownloaderProgress)downloadProgress completion:(PPImageDownloaderCompletion)completion
{
    PPImageDownloaderTask *task = [PPImageDownloaderTask taskForURL:URL.absoluteString];
    task.downloadProgress = downloadProgress;
    task.completion = completion;
    PPAsyncExecuteIn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDownloadTask *sessionTask = [task createSessionTaskIfNecessaryWithBlock:^NSURLSessionDownloadTask * _Nonnull{
            return [_session downloadTaskWithURL:URL];
        }];
        if (sessionTask) {
            [sessionTask resume];
        }
    });
    return task;
}

- (PPImageDownloaderTask *)fetchDownloaderTaskWithURL:(NSString *)URL
{
    [_lock lock];
    PPImageDownloaderTask *task = [PPImageDownloader sharedImageDownloader].downloaderTasks[URL];
    [_lock unlock];
    
    if (!task) {
        task = [[PPImageDownloaderTask alloc] initWithURL:URL];
    }
    
    [_lock lock];
    [PPImageDownloader sharedImageDownloader].downloaderTasks[URL] = task;
    [_lock unlock];
    
    return task;
}

- (void)cancelImageDownloaderWithTask:(PPImageDownloaderTask *)downloaderTask
{
    [downloaderTask cancel];
    
    [_lock lock];
    [[PPImageDownloader sharedImageDownloader].downloaderTasks removeObjectForKey:downloaderTask.URL];
    [_lock unlock];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    PPImageDownloaderTask *task = _downloaderTasks[downloadTask.originalRequest.URL.absoluteString];
    if (task.downloadProgress) {
        PPAsyncExecuteInMainQueue(^{
            task.downloadProgress((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    PPImageDownloaderTask *task = _downloaderTasks[downloadTask.originalRequest.URL.absoluteString];
    NSData *data = [NSData dataWithContentsOfURL:location];
    [[PPImageCache sharedCache] storeImageDataToDisk:data forURL:task.URL];
    
    if (task.isCancelled) {
        return;
    }
    if (task.completion) {
        UIImage *image = [PPImageDecode imageWithData:data];
        image = [PPImageDecode decodeImageWithImage:image];
        PPAsyncExecuteInMainQueue(^{
            task.completion(image, nil);
        });
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    PPImageDownloaderTask *_task = _downloaderTasks[task.originalRequest.URL.absoluteString];
    
    if (_task.completion && error) {
        PPAsyncExecuteInMainQueue(^{
            _task.completion(nil, error);
        });
    }
}

@end
