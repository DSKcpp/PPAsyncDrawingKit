//
//  PPImageLoadOperation.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/24.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageLoadOperation.h"
#import "PPImageCache.h"
#import "PPWebImageManager.h"

@interface PPImageLoadOperation () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, assign) float lastNotifiedProgress;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation PPImageLoadOperation

+ (NSThread *)networkRequestThread
{
    static NSThread *thread;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint) object:nil];
        [thread start];
    });
    return thread;
}

+ (void)networkRequestThreadEntryPoint
{
    @autoreleasepool {
        NSThread *currentThread = [NSThread currentThread];
        currentThread.name = @"PPImageLoadOperation";
        NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
        [currentRunloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [currentRunloop run];
    }
}

+ (instancetype)operationWithURL:(NSString *)URL
{
    return [[PPImageLoadOperation alloc] initWithURL:URL];
}

- (instancetype)initWithURL:(NSString *)URL
{
    if (self = [super init]) {
        _imageURL = URL;
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        self.minNotifiProgressInterval = 0.05f;
    }
    return self;
}

- (void)main
{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@>", self.class, self, _imageURL];
}

- (void)start
{
    self.lastNotifiedProgress = 0;
    if (self.cancelled) {
//        self.finished = YES;
        NSError *error = [NSError errorWithDomain:@"PPImageRequestErrorDomainCanceled" code:1001 userInfo:nil];
        [self.delegate imageLoadCompleted:self image:nil data:nil error:error isCache:NO];
    } else {
//        self.executing = YES;
        UIImage *image = [[PPImageCache sharedCache] imageForURL:_imageURL];
        if (!image && [_imageURL hasPrefix:@"/"]) {
            image = [UIImage imageWithContentsOfFile:_imageURL];
        }
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.finished = YES;
                _progress = 1.0f;
                if ([self.delegate respondsToSelector:@selector(imageLoadOperation:didReceivedSize:expectedSize:)]) {
                    [self.delegate imageLoadOperation:self didReceivedSize:0 expectedSize:0];
                }
                [self.delegate imageLoadCompleted:self image:image data:nil error:nil isCache:YES];
            });
        } else {
            [self reloadConnection];
        }
    }
}

- (void)cancel
{
    if (!self.finished) {
        [super cancel];
//        _downloadTask 
//        if (connection) {
//            [connection cancel];
////            self.finished = YES;
//        }
    }
}

- (void)reloadConnection
{
//    [self.connection cancel];
//    self.connection = nil;
//    if (!self.connection) {
//        self.loadedSize = 0;
//    }
//    if (!self.connection) {
//        NSURL *URL = [NSURL URLWithString:_imageURL];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:0 timeoutInterval:60];
//        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
//    }
//    if (self.connection) {
//        NSThread *requestThread = [[self class] networkRequestThread];
//        [self performSelector:@selector(connectionDidStart)
//                     onThread:requestThread
//                   withObject:nil
//                waitUntilDone:NO
//                        modes:@[NSRunLoopCommonModes]];
//    }
    _downloadTask = [_session downloadTaskWithURL:[NSURL URLWithString:_imageURL]];
    NSThread *requestThread = [[self class] networkRequestThread];
    [self performSelector:@selector(connectionDidStart)
                 onThread:requestThread
               withObject:nil
            waitUntilDone:NO
                    modes:@[NSRunLoopCommonModes]];
    [_downloadTask resume];
}

- (void)connectionDidStart
{
    if (!self.isCancelled) {
        if (_downloadTask) {
            _startTime = [[NSDate date] timeIntervalSince1970];
            [_downloadTask resume];
        }
//        if (self.connection) {
//            self.startTime = [[NSDate date] timeIntervalSince1970];
//            [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//            [self.connection start];
//        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *file = [[PPImageCache sharedCache].cachePath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:file] error:nil];
    NSData *data = [NSData dataWithContentsOfFile:file];
    UIImage *image = [UIImage imageWithData:data];
    if ([_delegate respondsToSelector:@selector(imageLoadCompleted:image:data:error:isCache:)]) {
        [_delegate imageLoadCompleted:self image:image data:data error:nil isCache:NO];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if ([_delegate respondsToSelector:@selector(imageLoadOperation:didReceivedSize:expectedSize:)]) {
        [_delegate imageLoadOperation:self didReceivedSize:totalBytesWritten expectedSize:totalBytesExpectedToWrite];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

@end
