//
//  PPAsyncDrawingView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PPAsyncDrawingPolicy) {
    PPAsyncDrawingPolicyNone,
    PPAsyncDrawingPolicyMainThread,
    PPAsyncDrawingPolicyMultiThread
};

/**
 PPAsyncDrawingView is a base class, can not be used directly, need to use inheritance.
 */
@interface PPAsyncDrawingView : UIView

/**
 default is YES, Globally async drawing enabled.
 */
@property (nonatomic, class, assign) BOOL globallyAsyncDrawingEnabled;
@property (nullable, nonatomic, assign) dispatch_queue_t drawQueue;
@property (nonatomic, assign) BOOL reservePreviousContents;
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;
@property (nonatomic, assign) PPAsyncDrawingPolicy drawingPolicy;
@property (nonatomic, assign, readonly) NSUInteger drawingCount;

- (instancetype)initWithFrame:(CGRect)frame;

- (nullable NSDictionary *)currentDrawingUserInfo;

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously;
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(nullable NSDictionary *)userInfo;

- (void)drawingWillStartAsynchronously:(BOOL)asynchronously;
- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success;

- (void)setNeedsDisplayAsync;
@end

NS_ASSUME_NONNULL_END
