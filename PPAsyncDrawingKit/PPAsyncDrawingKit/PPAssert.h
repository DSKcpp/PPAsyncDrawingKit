//
//  PPAssert.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/12.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/NSException.h>
#import <pthread.h>

#define PPAssert(condition, desc, ...) NSAssert(condition, desc, ##__VA_ARGS__)

#define PPAssertAssertMainThread() PPASDKAssert(0 != pthread_main_np(), @"This method must be called on the main thread")
