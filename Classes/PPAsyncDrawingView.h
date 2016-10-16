//
//  PPAsyncDrawingView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PPAsyncDrawingViewLayer;

typedef NSInteger(^PPAsyncDrawingCompleted)(NSInteger success);

@interface PPAsyncDrawingView : UIView

@property (nonatomic, weak) PPAsyncDrawingViewLayer *drawingLayer;
@property (nonatomic, assign, readonly) BOOL padingRedraw;
@property (nonatomic, assign) BOOL serializesDrawingOperations;
@property (nonatomic, assign) NSInteger dispatchPriority;
@property (nonatomic, assign) dispatch_queue_t dispatchDrawQueue;
@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;
@property (nonatomic, assign) NSInteger drawingPolicy;
@property (nonatomic, assign) NSUInteger drawingCount;
@property (nonatomic, assign, readonly) BOOL alwaysUsesOffscreenRendering;

+ (BOOL)asyncDrawingDisabledGlobally;
+ (void)setDisablesAsyncDrawingGlobally:(BOOL)asyncDrawingDisabledGlobally;

- (void)interruptDrawingWhenPossible;
- (dispatch_queue_t)drawQueue;
- (void)redraw;
- (CGContextRef)newCGContextForLayer:(CALayer *)layer;
- (void)drawingWillStartAsynchronously:(BOOL)async;
- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success;
- (void)_displayLayer:(PPAsyncDrawingViewLayer *)layer rect:(CGRect)rect drawingStarted:(PPAsyncDrawingCompleted)drawingStarted drawingFinished:(PPAsyncDrawingCompleted)drawingFinished drawingInterrupted:(PPAsyncDrawingCompleted)drawingInterrupted;
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(id)userInfo;
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async;
@end

NS_ASSUME_NONNULL_END
