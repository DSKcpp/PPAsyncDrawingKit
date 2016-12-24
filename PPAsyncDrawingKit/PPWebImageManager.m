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
@property (nonatomic, strong) NSMutableDictionary<NSString *, PPImageLoadRequest *> *requests;
@property (nonatomic, strong) NSOperationQueue *loadQueue;
@property (nonatomic, strong) PPImageCache *cache;
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

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL complete:(nonnull PPImageLoadCompleteBlock)complete
{
    return [self loadImage:imageURL progress:nil complete:complete];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete
{
    return [self loadImage:imageURL delegate:self progress:progress complete:complete];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete isPermenant:(BOOL)permenant
{
    return [self loadImage:imageURL delegate:self alternativeUrls:nil progress:progress complete:complete autoCancel:YES options:0 isPermenant:permenant];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete
{
    return [self loadImage:imageURL delegate:delegate progress:progress complete:complete autoCancel:YES];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel
{
    return [self loadImage:imageURL delegate:delegate alternativeUrls:nil progress:progress complete:complete autoCancel:autoCancel];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel cacheType:(PPImageCacheType)cacheType
{
    return [self loadImage:imageURL delegate:delegate alternativeUrls:nil progress:progress complete:complete autoCancel:autoCancel cacheType:cacheType];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate alternativeUrls:(id)alternativeUrls progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel
{
    return [self loadImage:imageURL delegate:delegate alternativeUrls:alternativeUrls progress:progress complete:complete autoCancel:autoCancel options:0];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate alternativeUrls:(id)alternativeUrls progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel options:(long long)options
{
    return [self loadImage:imageURL delegate:delegate alternativeUrls:alternativeUrls progress:progress complete:complete autoCancel:autoCancel options:options isPermenant:NO];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate alternativeUrls:(id)alternativeUrls progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel options:(long long)options isPermenant:(BOOL)permenant
{
    return [self loadImage:imageURL delegate:delegate alternativeUrls:alternativeUrls progress:progress complete:complete autoCancel:autoCancel options:options isPermenant:permenant cacheType:kNilOptions];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate alternativeUrls:(id)alternativeUrls progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel options:(long long)options cacheType:(PPImageCacheType)cacheType
{
    return [self loadImage:imageURL delegate:delegate alternativeUrls:alternativeUrls progress:progress complete:complete autoCancel:autoCancel options:options isPermenant:NO cacheType:cacheType];
}

- (PPImageLoadRequest *)loadImage:(NSString *)imageURL delegate:(id)delegate alternativeUrls:(id)alternativeUrls progress:(PPImageLoadProgressBlock)progress complete:(nonnull PPImageLoadCompleteBlock)complete autoCancel:(BOOL)autoCancel options:(long long)options isPermenant:(BOOL)permenant cacheType:(PPImageCacheType)cacheType
{
    if (imageURL.length) {
        PPImageLoadRequest *request = [[PPImageLoadRequest alloc] initWithURL:imageURL];
        request.completedBlock = complete;
        request.progressBlock = progress;
        request.alternativeUrls = alternativeUrls;
        request.owner = delegate;
        request.cancelForOwnerDealloc = autoCancel;
        request.options = options;
        request.isPermenant = permenant;
        [self addRequest:request];
        return request;
    } else {
        return nil;
    }
}

- (void)addRequest:(PPImageLoadRequest *)request
{
//    PPImageLoadRequest *r = [self.requests objectForKey:request.imageURL];
    PPImageLoadOperation *o = [self operationForURL:request.imageURL];
    if (o) {
        
    } else {
        PPImageLoadOperation *opertation = [PPImageLoadOperation operationWithURL:request.imageURL];
        opertation.delegate = request.owner;
        [_loadQueue addOperation:opertation];
        [self.requests setObject:request forKey:request.imageURL];
    }
    if (request.alternativeUrls.count) {
        
    }
//    dispatch_async(self.imageLoadQueue, ^{
//        PPImageLoadRequest *request = [self.requests objectForKey:request.imageURL];
//        if (request == nil) {
//            
//        }
//    });
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
    PPImageLoadRequest *request = [self.requests objectForKey:imageLoadOperation.imageURL];
    if (request.completedBlock) {
        request.completedBlock(image, data, error);
    }
}
@end
