//
//  PPAsyncDrawingView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <stdatomic.h>

@class PPAsyncDrawingViewLayer;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PPAsyncDrawingPolicy) {
    PPAsyncDrawingPolicyNone,
    PPAsyncDrawingPolicyMainThread,
    PPAsyncDrawingPolicyMultiThread
};

typedef NS_ENUM(NSUInteger, PPAsyncDrawingDispatchQueuePriorty) {
    PPAsyncDrawingDispatchQueuePriortyDefault = 0,
    PPAsyncDrawingDispatchQueuePriortyHigh = 2,
    PPAsyncDrawingDispatchQueuePriortyLow = -2,
    PPAsyncDrawingDispatchQueuePriortyBackground = INT16_MIN
};

/**
 PPAsyncDrawingView is a base class, can not be used directly, need to use inheritance.
 */
@interface PPAsyncDrawingView : UIView

/**
 default is YES, Globally async drawing enabled.
 */
@property (nonatomic, class, assign) BOOL globallyAsyncDrawingEnabled;
@property (nullable, nonatomic, assign) dispatch_queue_t dispatchDrawQueue;
@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;
@property (nonatomic, assign) PPAsyncDrawingPolicy drawingPolicy;
@property (nonatomic, assign) PPAsyncDrawingDispatchQueuePriorty dispatchPriority;
@property (nonatomic, assign, readonly) NSUInteger drawingCount;
@property (nonatomic, assign, readonly) BOOL alwaysUsesOffscreenRendering;

- (instancetype)initWithFrame:(CGRect)frame;

- (dispatch_queue_t)drawQueue;
- (PPAsyncDrawingViewLayer *)drawingLayer;
- (nullable NSDictionary *)currentDrawingUserInfo;
- (void)drawingWillStartAsynchronously:(BOOL)async;
- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success;
- (BOOL)drawInRect:(CGRect)rect withContext:(nullable CGContextRef)context asynchronously:(BOOL)async;
- (BOOL)drawInRect:(CGRect)rect withContext:(nullable CGContextRef)context asynchronously:(BOOL)async userInfo:(nullable NSDictionary *)userInfo;

- (void)setNeedsDisplayAsync;
@end

@interface PPAsyncDrawingViewLayer : CALayer

/**
 下一次 Drawing 完成之前是否要保留之前的 Contnets，默认 NO
 */
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;

@property (nonatomic, assign) PPAsyncDrawingPolicy drawingPolicy;
@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, assign, readonly) atomic_int drawingCount;

- (void)increaseDrawingCount;
- (BOOL)drawsCurrentContentAsynchronously;
@end

NS_ASSUME_NONNULL_END
