//
//  PPImageLoadOperation.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/24.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageLoadOperation.h"
#import "PPImageCache.h"

@interface PPImageLoadOperation ()
@property (nonatomic, assign) float lastNotifiedProgress;
@property (nonatomic, strong) NSRecursiveLock *streamLock;
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
        [[NSRunLoop currentRunLoop] run];
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
        self.executing = YES;
        UIImage *image = [[PPImageCache sharedCache] imageForURL:_imageURL isPermanent:self.isPermenant];
        if (!image) {
            image = [UIImage imageWithContentsOfFile:_imageURL];
        }
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.finished = YES;
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
        NSURLConnection *connection = [self connection];
        if (connection) {
            [connection cancel];
            self.finished = YES;
        }
        [self.streamLock lock];
        [self.outStream close];
        [self.streamLock unlock];
    }
}

- (void)reloadConnection
{
    [self.connection cancel];
    self.connection = nil;
    if (!self.connection) {
        self.loadedSize = 0;
    }
}
@end
