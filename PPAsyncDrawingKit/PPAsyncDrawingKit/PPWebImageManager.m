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

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL complete:(PPInternalCompletionBlock)complete
{
    return [self loadImage:imageURL progress:nil complete:complete autoCancel:YES cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL progress:(PPWebImageDownloaderProgressBlock)progress complete:(PPInternalCompletionBlock)complete
{
    return [self loadImage:imageURL progress:progress complete:complete autoCancel:YES cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL progress:(PPWebImageDownloaderProgressBlock)progress complete:(PPInternalCompletionBlock)complete cacheType:(PPImageCacheType)cacheType
{
    return [self loadImage:imageURL progress:progress complete:complete autoCancel:YES cacheType:cacheType];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL progress:(PPWebImageDownloaderProgressBlock)progress complete:(PPInternalCompletionBlock)complete autoCancel:(BOOL)autoCancel
{
    return [self loadImage:imageURL progress:progress complete:complete autoCancel:autoCancel cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL progress:(PPWebImageDownloaderProgressBlock)progress complete:(PPInternalCompletionBlock)complete autoCancel:(BOOL)autoCancel cacheType:(PPImageCacheType)cacheType
{
    if (imageURL.length) {
        PPImageLoadRequest *request = [[PPImageLoadRequest alloc] initWithURL:imageURL];
        request.completedBlock = complete;
        request.progressBlock = progress;
        [self addRequest:request];
        return request;
    } else {
        return nil;
    }
}

- (void)addRequest:(PPImageLoadRequest *)request
{
    __weak typeof(self) weakSelf = self;
    NSOperation *cacheOperation = [_cache imageForURL:request.imageURL callback:^(UIImage * _Nullable image, PPImageCacheType cacheType) {
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    request.image = image;
                    [request requestDidFinish];
                });
            } else {
                @synchronized (weakSelf) {
                    NSMutableArray<PPImageLoadRequest *> *loadingRequests = weakSelf.requests[request.imageURL];
                    if (!loadingRequests) {
                        if (request.imageURL.length) {
                            loadingRequests = [NSMutableArray array];
                            [weakSelf.requests setObject:loadingRequests forKey:request.imageURL];
                        }
                    }
                    [loadingRequests addObject:request];
                }
                PPImageLoadOperation *operation = [weakSelf operationForURL:request.imageURL];
                if (!operation) {
                    operation = [PPImageLoadOperation operationWithURL:request.imageURL];
                    operation.delegate = weakSelf;
                    [weakSelf.loadQueue addOperation:operation];
                }
            }
    }];
//    request.operation = cacheOperation;
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

- (void)cancelRequestForKey:(NSString *)key
{
    NSArray<NSMutableArray<PPImageLoadRequest *> *> *requests;
    @synchronized (self) {
        requests = [NSArray arrayWithArray:_requests.allValues];
    }
    
    for (NSMutableArray<PPImageLoadRequest *> *r in requests) {
        [r enumerateObjectsUsingBlock:^(PPImageLoadRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.key) {
//                if ([obj.key isEqualToString:key]) {
//                    [obj cancel];
//                }
//            }
            [obj cancel];
        }];
    }
}

- (void)resumeImageLoad
{
    if (_loadQueue.isSuspended) {
        _loadQueue.suspended = NO;
    }
}

- (void)suspendImageLoad
{
    if (!_loadQueue.isSuspended) {
        _loadQueue.suspended = YES;
    }
}

- (BOOL)imageLoadSuspended
{
    return _loadQueue.isSuspended;
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

//- (void)addReadingOperation:(NSOperation *)operation withKey:(NSString *)key
//{
//    if (key) {
//        [self cancelReadingOperationWithKey:key];
//        if (operation) {
//            [self.readingOperations setObject:operation forKey:key];
//        }
//    }
//}
//
//- (void)cancelReadingOperationWithKey:(NSString *)key
//{
//    id operations = self.readingOperations[key];
//    if (operations) {
//        if ([operations isKindOfClass:[NSArray class]]) {
//            for (NSOperation *operation in operations) {
//                if (operation) {
//                    [operation cancel];
//                }
//            }
//        } else if ([operations isKindOfClass:[NSOperation class]]){
//            [operations cancel];
//        }
//        [self removeReadingOperationWithKey:key];
//    }
//}
//
//- (void)removeReadingOperationWithKey:(NSString *)key
//{
//    [self.readingOperations removeObjectForKey:key];
//}

- (void)imageLoadCompleted:(PPImageLoadOperation *)imageLoadOperation image:(UIImage *)image data:(NSData *)data error:(NSError *)error isCache:(BOOL)isCache
{
    if (image && !isCache) {
        [_cache storeImage:image data:data forURL:imageLoadOperation.imageURL toDisk:YES];
    }
    NSString *URL = imageLoadOperation.imageURL;
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

- (void)imageLoadOperation:(PPImageLoadOperation *)imageLoadOperation didReceivedSize:(int64_t)receivedSize expectedSize:(int64_t)expectedSize
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized (self) {
            NSMutableArray<PPImageLoadRequest *> *requests = _requests[imageLoadOperation.imageURL];
            if (requests) {
                for (PPImageLoadRequest *request in requests) {
                    [request didReceiveDataSize:receivedSize expectedSize:expectedSize];
                }
            }
        }
    });
}

- (NSString *)pathOfFileForOperation:(PPImageLoadOperation *)imageLoadOperation
{
    return [_cache diskCachePathForImageURL:imageLoadOperation.imageURL];
}
@end
