//
//  PPLock.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/20.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPLock.h"
#import <pthread/pthread.h>

@interface PPLock ()
{
    pthread_mutex_t _mutex;
}
@end

@implementation PPLock
- (instancetype)init
{
    if (self = [super init]) {
        int result = pthread_mutex_init(&_mutex, NULL);
        NSAssert(result == 0, @"Failed to initialize mutex with error %zd.", result);
    }
    return self;
}

- (void)lock
{
    int result = pthread_mutex_lock(&_mutex);
    NSAssert(result == 0, @"Failed to lock mutex with error %zd.", result);
}

- (void)unlock
{
    int result = pthread_mutex_unlock(&_mutex);
    NSAssert(result == 0, @"Failed to unlock mutex with error %zd.", result);
}

- (void)dealloc
{
    int result = pthread_mutex_destroy(&_mutex);
    NSAssert(result == 0, @"Failed to destroy mutex with error %zd.", result);
}
@end
