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
@property (nonatomic, strong) NSMutableDictionary<NSString *, PPImageLoadRequest *> *requests;
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
    return [self loadImage:imageURL delegate:self progress:nil complete:complete autoCancel:YES options:0 cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete
{
    return [self loadImage:imageURL delegate:self progress:progress complete:complete autoCancel:YES options:0 cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id<PPImageLoadOperationDelegate>)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:YES options:0 cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id<PPImageLoadOperationDelegate>)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete cacheType:(PPImageCacheType)cacheType
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:YES options:0 cacheType:cacheType];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id<PPImageLoadOperationDelegate>)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:autoCancel options:0 cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id<PPImageLoadOperationDelegate>)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel options:(long long)options
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:autoCancel options:options cacheType:PPImageCacheTypeAll];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id<PPImageLoadOperationDelegate>)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel cacheType:(PPImageCacheType)cacheType
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:autoCancel options:0 cacheType:cacheType];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id<PPImageLoadOperationDelegate>)delegate progress:(PPImageLoadProgressBlock)progress complete:(PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel options:(long long)options cacheType:(PPImageCacheType)cacheType
{
    if (imageURL.length) {
        PPImageLoadRequest *request = [[PPImageLoadRequest alloc] initWithURL:imageURL];
        request.completedBlock = complete;
        request.progressBlock = progress;
        request.owner = delegate;
        request.cancelForOwnerDealloc = autoCancel;
        request.options = options;
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
    __block UIImage *image;
    
    dispatch_sync(self.imageLoadQueue, ^{
        image = [_cache imageForURL:request.imageURL taskKey:request.imageURL];
    });
    
    if (image) {
        request.image = image;
        request.progress = 1.0f;
        [request requestDidFinish];
    } else {
        PPImageLoadRequest *r = [self.requests objectForKey:request.imageURL];
        if (!r) {
            [self.requests setObject:request forKey:request.imageURL];
        }
        PPImageLoadOperation *o = [self operationForURL:request.imageURL];
        if (o) {
            o.completionBlock = ^(void) {
                UIImage *image = [_cache imageForURL:request.imageURL taskKey:request.imageURL];
                request.image = image;
                request.progress = 1.0f;
                [request requestDidFinish];
            };
        } else {
            PPImageLoadOperation *operation = [PPImageLoadOperation operationWithURL:request.imageURL];
            operation.minNotifiProgressInterval = 1;
            operation.delegate = request.owner;
            [_loadQueue addOperation:operation];
        }
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
    if (!error) {
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        PPImageLoadRequest *request = [self.requests objectForKey:imageLoadOperation.imageURL];
        if (request.imageURL.length) {
            [_requests removeObjectForKey:request.imageURL];
        }
        request.image = image;
        request.data = data;
        request.error = error;
        [request requestDidFinish];
    });
}
@end
