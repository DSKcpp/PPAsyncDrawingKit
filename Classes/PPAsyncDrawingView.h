//
//  PPAsyncDrawingView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPAsyncDrawingViewLayer;

struct flags {
    NSUInteger tiledDrawingEnabled: 1;
};

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

- (void)interruptDrawingWhenPossible;
- (void)_setDispatchDrawQueue:(dispatch_queue_t)dispatchDrawQueue;
- (dispatch_queue_t)drawQueue;
- (void)redraw;
- (void)_displayLayer:(PPAsyncDrawingViewLayer *)layer rect:(CGRect)rect drawingStarted:(id)arg3 drawingFinished:(id)arg4 drawingInterrupted:(id)arg5;
+ (BOOL)asyncDrawingDisabledGlobally;
+ (void)setDisablesAsyncDrawingGlobally:(BOOL)asyncDrawingDisabledGlobally;
- (CGContextRef)newCGContextForLayer:(CALayer *)layer;
- (void)drawingWillStartAsynchronously:(BOOL)async;
- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success;
@end
