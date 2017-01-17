//
//  PPImageDownloader.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/17.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPImageDownloader.h"
#import "PPImage.h"
#import "PPImageCache.h"

@interface PPImageDownloaderTask ()
{
    NSURLSessionDownloadTask *_sessionDownloadTask;
}
@end

@implementation PPImageDownloaderTask
+ (PPImageDownloaderTask *)taskForURL:(NSURL *)URL
{
    PPImageDownloaderTask *task = [PPImageDownloader sharedImageDownloader].downloaderTasks[URL.absoluteString];
    if (!task) {
        task = [[PPImageDownloaderTask alloc] initWithURL:URL];
        [PPImageDownloader sharedImageDownloader].downloaderTasks[URL.absoluteString] = task;
    }
    return task;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init]) {
        _URL = URL;
    }
    return self;
}

- (BOOL)isCancelled
{
    return NO;
}

- (void)setSessionDownloadTask:(NSURLSessionDownloadTask *)sessionDownloadTask
{
    _sessionDownloadTask = sessionDownloadTask;
}

- (void)cancel
{
    [_sessionDownloadTask cancel];
    [[PPImageDownloader sharedImageDownloader].downloaderTasks removeObjectForKey:_URL.absoluteString];
}

@end

@interface PPImageDownloader () <NSURLSessionDownloadDelegate>
{
    NSOperationQueue *_sessionDelegateQueue;
    NSURLSession *_session;
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
        _sessionDelegateQueue = [[NSOperationQueue alloc] init];
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:_sessionDelegateQueue];
        _downloaderTasks = @{}.mutableCopy;
    }
    return self;
}

- (PPImageDownloaderTask *)downloaderImageWithURL:(NSURL *)URL downloadProgress:(PPImageDownloaderProgress)downloadProgress completion:(PPImageDownloaderCompletion)completion
{
    PPImageDownloaderTask *task = [PPImageDownloaderTask taskForURL:URL];
    task.downloadProgress = downloadProgress;
    task.completion = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDownloadTask *sessionTask = [_session downloadTaskWithURL:URL];
        if (sessionTask) {
            [task setSessionDownloadTask:sessionTask];
            [sessionTask resume];
        }
    });
    return task;
}

- (void)cancelImageDownloaderWithTask:(PPImageDownloaderTask *)downloaderTask
{
    [downloaderTask cancel];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    PPImageDownloaderTask *task = _downloaderTasks[downloadTask.originalRequest.URL.absoluteString];
    if (task.downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            task.downloadProgress((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    PPImageDownloaderTask *task = _downloaderTasks[downloadTask.originalRequest.URL.absoluteString];
    NSData *data = [NSData dataWithContentsOfURL:location];
    [[PPImageCache sharedCache] storeImageDataToDisk:data forURL:task.URL.absoluteString];
    
    if (task.isCancelled) {
        return;
    }
    if (task.completion) {
        UIImage *image = [PPImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            task.completion(image, nil);
        });
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    PPImageDownloaderTask *_task = _downloaderTasks[task.originalRequest.URL.absoluteString];
    
    if (_task.completion && error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _task.completion(nil, error);
        });
    }
}

@end
