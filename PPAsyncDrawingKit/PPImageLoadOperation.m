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
#import "PPImage.h"
#import "PPImageLoadRequest.h"

@interface PPImageLoadOperation () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, assign) float lastNotifiedProgress;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) UIImage *resultImage;
@property (nonatomic, strong) NSData *resultData;
@end

@implementation PPImageLoadOperation
@synthesize finished = _finished;
@synthesize executing = _executing;

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
        self.minNotifiProgressInterval = 0.05f;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@>", self.class, self, _imageURL];
}

- (void)start
{
    self.lastNotifiedProgress = 0;
    if (self.cancelled) {
        self.finished = YES;
        NSError *error = [NSError errorWithDomain:@"PPImageRequestErrorDomainCanceled" code:1001 userInfo:nil];
        [self.delegate imageLoadCompleted:self image:nil data:nil error:error isCache:NO];
    } else {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 15;
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        self.executing = YES;
        [self reloadConnection];
    }
    
//        UIImage *image = [[PPImageCache sharedCache] imageForURL:_imageURL];
//        if (!image && [_imageURL hasPrefix:@"/"]) {
//            image = [UIImage imageWithContentsOfFile:_imageURL];
//        }
//        if (image) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.finished = YES;
//                [self cancel];
//                _progress = 1.0f;
//                if ([self.delegate respondsToSelector:@selector(imageLoadOperation:didReceivedSize:expectedSize:)]) {
//                    [self.delegate imageLoadOperation:self didReceivedSize:0 expectedSize:0];
//                }
//                [self.delegate imageLoadCompleted:self image:image data:nil error:nil isCache:YES];
//            });
//        } else {
//            [self reloadConnection];
//        }
//    }
}

- (void)cancel
{
    if (!self.finished) {
        [super cancel];
        if (_downloadTask) {
            [_downloadTask cancel];
        }
        if (_executing) {
            self.executing = NO;
        }
        if (!_finished) {
            self.finished = YES;
        }
    }
    [self reset];
}

- (void)reset
{
    [_session invalidateAndCancel];
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isExecuting
{
    return _executing;
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)reloadConnection
{
    _downloadTask = [_session downloadTaskWithURL:[NSURL URLWithString:_imageURL]];
    NSThread *requestThread = [PPImageLoadOperation networkRequestThread];
    [self performSelector:@selector(connectionDidStart)
                 onThread:requestThread
               withObject:nil
            waitUntilDone:NO
                    modes:@[NSRunLoopCommonModes]];
}

- (void)connectionDidStart
{
    if (!self.isCancelled) {
        if (_downloadTask) {
            _startTime = [[NSDate date] timeIntervalSince1970];
            [_downloadTask resume];
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
    }
    if ([_delegate respondsToSelector:@selector(imageLoadCompleted:image:data:error:isCache:)]) {
        [_delegate imageLoadCompleted:self image:_resultImage data:_resultData error:error isCache:NO];
        self.finished = YES;
        self.executing = NO;
        [self reset];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *file = [[PPImageCache sharedCache].cachePath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:file] error:nil];
    _resultData = [NSData dataWithContentsOfFile:file];
    _resultImage = [PPImage imageWithData:_resultData];
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

- (void)dealloc
{
    
}
@end
