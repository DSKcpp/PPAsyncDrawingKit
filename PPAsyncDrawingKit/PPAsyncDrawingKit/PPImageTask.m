//
//  PPImageTask.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/3/1.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPImageTask.h"
#import "PPLock.h"
#import "PPImageCache.h"
#import "PPImageDownloader.h"

@interface PPImageIOTask ()
{
    BOOL _invalid;
    PPLock *_lock;
}
@end


@implementation PPImageIOTask
@synthesize URL = _URL;

+ (PPImageIOTask *)taskForURL:(NSString *)URL
{
    return [[PPImageCache sharedCache] fetchIOTaskWithURL:URL];
}

- (instancetype)initWithURL:(NSString *)URL
{
    if (self = [super init]) {
        _URL = URL;
        _lock = [[PPLock alloc] init];
    }
    return self;
}

- (BOOL)isCancelled
{
    [_lock lock];
    BOOL invalid = _invalid;
    [_lock unlock];
    return invalid;
}

- (void)cancel
{
    [_lock lock];
    _invalid = YES;
    [_lock unlock];
}

@end

@interface PPImageDownloaderTask ()
{
    BOOL _invalid;
    PPLock *_lock;
}
@end

@implementation PPImageDownloaderTask
@synthesize URL = _URL;

+ (PPImageDownloaderTask *)taskForURL:(NSString *)URL
{
    return [[PPImageDownloader sharedImageDownloader] fetchDownloaderTaskWithURL:URL];
}

- (instancetype)initWithURL:(NSString *)URL
{
    if (self = [super init]) {
        _URL = URL;
        _lock = [[PPLock alloc] init];
    }
    return self;
}

- (BOOL)isCancelled
{
    [_lock lock];
    BOOL invalid = _invalid;
    [_lock unlock];
    return invalid;
}

- (void)cancel
{
    [_lock lock];
    _invalid = YES;
    [_lock unlock];
    
    [_sessionDownloadTask cancel];
}

- (NSURLSessionDownloadTask *)createSessionTaskIfNecessaryWithBlock:(NSURLSessionDownloadTask *(^)())creationBlock
{
    if (self.isCancelled) {
        return nil;
    }
    
    if (self.sessionDownloadTask && (self.sessionDownloadTask.state == NSURLSessionTaskStateRunning)) {
        return nil;
    }
    
    NSURLSessionDownloadTask *newTask = creationBlock();
    
    if (self.isCancelled) {
        return nil;
    }
    
    if (self.sessionDownloadTask && (self.sessionDownloadTask.state == NSURLSessionTaskStateRunning)) {
        return nil;
    }
    
    self.sessionDownloadTask = newTask;
    
    return self.sessionDownloadTask;
}

@end
