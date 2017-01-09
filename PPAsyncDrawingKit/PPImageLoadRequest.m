//
//  PPImageLoadRequest.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/24.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageLoadRequest.h"

@interface PPImageLoadRequest ()
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, assign) float lastNotifiedProgress;
@end

@implementation PPImageLoadRequest
- (instancetype)initWithURL:(NSString *)URL
{
    if (self = [super init]) {
        self.cancelForOwnerDealloc = NO;
        _imageURL = URL;
        self.minNotifiProgressInterval = 0.05f;
    }
    return self;
}

- (void)start
{
    [[PPWebImageManager sharedManager] addRequest:self];
}

- (BOOL)finished
{
    return self.finished;
}

- (BOOL)failed
{
    if (self.finished) {
        if (!self.image) {
            return YES;
        }
    }
    return NO;
}

- (void)cancel
{
    self.owner = nil;
    [[PPWebImageManager sharedManager] cancelRequest:self];
}

- (void)retry
{
    if (self.failed) {
        self.finished = NO;
        self.image = nil;
        self.data = nil;
        self.progress = 0.0f;
        [self start];
    }
}

- (void)didReceiveDataSize:(int64_t)reveiveSize expectedSize:(int64_t)expectedSize
{
    float progress = reveiveSize / expectedSize;
    self.progress = progress;
    if (progress - _lastNotifiedProgress > _minNotifiProgressInterval) {
        _lastNotifiedProgress = progress;
        if (_progressBlock) {
            _progressBlock(reveiveSize, expectedSize, self.imageURL);
        }
    }
}

- (void)requestDidCancel
{
    self.image = nil;
    self.data = nil;
    NSError *error = [NSError errorWithDomain:@"PPImageRequestErrorDomainCanceled" code:1000 userInfo:nil];
    self.error = error;
    self.completedBlock = nil;
    self.progressBlock = nil;
}

- (void)requestDidFinish
{
    if (_completedBlock) {
        _completedBlock(_image, _data, _error);
    }
}

- (NSInteger)retryCount
{
    return self.retryCount;
}

@end
