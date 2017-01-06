//
//  PPWebImageManager.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/24.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPWebImageManager.h"
#import "PPImageLoadRequest.h"
#import "PPImageCache.h"

@interface PPWebImageManager ()
@property (nonatomic, strong) NSOperationQueue *loadQueue;
@property (nonatomic, strong) PPImageCache *cache;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<PPImageLoadRequest *> *> *requests;
@end

@implementation PPWebImageManager
+ (PPWebImageManager *)sharedManager
{
    static PPWebImageManager *_sharedManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.requests = @{}.mutableCopy;
        self.loadQueue = [[NSOperationQueue alloc] init];
        self.loadQueue.maxConcurrentOperationCount = 5;
        self.cache = [PPImageCache sharedCache];
    }
    return self;
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL complete:(PPImageLoadCompleteBlock)complete
{
    return [self loadImage:imageURL delegate:nil progress:nil complete:complete autoCancel:YES options:0 cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete
{
    return [self loadImage:imageURL delegate:nil progress:progress complete:complete autoCancel:YES options:0 cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id<PPImageLoadOperationDelegate>)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:YES options:0 cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete cacheType:(PPImageCacheType)cacheType
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:YES options:0 cacheType:cacheType];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:autoCancel options:0 cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel options:(long long)options
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:autoCancel options:options cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel cacheType:(PPImageCacheType)cacheType
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:autoCancel options:0 cacheType:cacheType];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel options:(long long)options cacheType:(PPImageCacheType)cacheType
{
    if (imageURL.length) {
        PPImageLoadRequest *request = [[PPImageLoadRequest alloc] initWithURL:imageURL];
        request.completedBlock = complete;
        request.progressBlock = progress;
        request.owner = delegate;
        request.cancelForOwnerDealloc = autoCancel;
        request.options = options;
        request.minNotifiProgressInterval = 0.05f;
        [self addRequest:request];
        return request;
    } else {
        return nil;
    }
}

- (dispatch_queue_t)imageLoadQueue
{
    if (!_imageLoadQueue) {
        _imageLoadQueue = dispatch_queue_create("io.github.dskcpp.imageLoad", NULL);
    }
    return _imageLoadQueue;
}

- (void)addRequest:(PPImageLoadRequest *)request
{
    void(^createOperation)(void) = ^(void) {
        @synchronized (self) {
            NSMutableArray<PPImageLoadRequest *> *loadingRequests = _requests[request.imageURL];
            if (!loadingRequests) {
                if (request.imageURL.length) {
                    loadingRequests = [NSMutableArray array];
                    [_requests setObject:loadingRequests forKey:request.imageURL];
                }
            }
            [loadingRequests addObject:request];
        }
        PPImageLoadOperation *operation = [self operationForURL:request.imageURL];
        if (operation) {
            operation.minNotifiProgressInterval = 0.05f;
        } else {
            operation = [PPImageLoadOperation operationWithURL:request.imageURL];
            operation.minNotifiProgressInterval = 1;
            operation.delegate = self;
            [_loadQueue addOperation:operation];
        }
    };
    
    if (self.imageLoadQueue) {
        dispatch_async(_imageLoadQueue, ^{
            UIImage *image = [_cache imageForURL:request.imageURL];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    request.image = image;
                    request.progress = 1.0f;
                    [request requestDidFinish];
                });
            } else {
                createOperation();
            }
        });
    } else {
        [_cache addToCurrentReadingTaskKeys:request.imageURL];
        UIImage *image = [_cache imageForURL:request.imageURL taskKey:request.imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                request.image = image;
                request.progress = 1.0f;
                [request requestDidFinish];
            } else {
                createOperation();
            }
        });
    }
}

- (void)cancelRequest:(PPImageLoadRequest *)request
{
    [request requestDidCancel];
    
    @synchronized (self) {
        NSMutableArray<PPImageLoadRequest *> *requests = _requests[request.imageURL];
        if (requests) {
            [_requests removeObjectForKey:request.imageURL];
        }
    }
    PPImageLoadOperation *operation = [self operationForURL:request.imageURL];
    [operation cancel];
}

- (void)cancelRequestForURL:(NSString *)URL
{
    @synchronized (self) {
        NSMutableArray<PPImageLoadRequest *> *requests = _requests[URL];
        for (PPImageLoadRequest *request in requests) {
            [request requestDidCancel];
        }
        [_requests removeObjectForKey:URL];
    }
    PPImageLoadOperation *operation = [self operationForURL:URL];
    [operation cancel];
}

- (void)cancelRequestForDelegate:(id)delegate
{
    NSArray<NSMutableArray<PPImageLoadRequest *> *> *requests;
    @synchronized (self) {
        requests = [NSArray arrayWithArray:_requests.allValues];
    }
    
    for (NSMutableArray<PPImageLoadRequest *> *r in requests) {
        [r enumerateObjectsUsingBlock:^(PPImageLoadRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.owner) {
                if (obj.owner == delegate) {
                    [obj cancel];
                }
            }
        }];
    }
}

- (PPImageLoadOperation *)operationForURL:(NSString *)URL
{
    for (PPImageLoadOperation *operation in _loadQueue.operations) {
        if ([operation.imageURL isEqualToString:URL]) {
            return operation;
        }
    }
    return nil;
}

- (PPImageCache *)cache
{
    return self.cache;
}

- (void)imageLoadCompleted:(PPImageLoadOperation *)imageLoadOperation image:(UIImage *)image data:(NSData *)data error:(NSError *)error isCache:(BOOL)isCache
{
    if (image && !isCache) {
        [_cache storeImage:image data:data forURL:imageLoadOperation.imageURL toDisk:YES];
    }
    NSString *URL = imageLoadOperation.imageURL;
    if (!error) {
        NSNotification *notification = [NSNotification notificationWithName:URL object:@{@"URL" : URL}];
        [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized (self) {
            NSMutableArray<PPImageLoadRequest *> *loadingRequests = [_requests objectForKey:URL];
            if (URL.length) {
                [_requests removeObjectForKey:URL];
            }
            for (PPImageLoadRequest * request in loadingRequests) {
                request.image = image;
                request.data = data;
                request.error = error;
                [request requestDidFinish];
            }
        }
    });
}

@end
