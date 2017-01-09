//
//  PPAsyncDrawingView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"
#import <libkern/OSAtomic.h>

@implementation PPAsyncDrawingView
static BOOL asyncDrawingEnabled = YES;

+ (Class)layerClass
{
    return [PPAsyncDrawingViewLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.drawingPolicy = PPAsyncDrawingTypeNone;
        self.dispatchPriority = PPAsyncDrawingDispatchQueuePriortyDefault;
        self.opaque = NO;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (NSDictionary *)currentDrawingUserInfo
{
    return nil;
}

- (void)setNeedsDisplayAsync
{
    [self setContentsChangedAfterLastAsyncDrawing:YES];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self drawingWillStartAsynchronously:NO];
    [self drawInRect:rect withContext:UIGraphicsGetCurrentContext() asynchronously:NO userInfo:[self currentDrawingUserInfo]];
    [self drawingDidFinishAsynchronously:NO success:YES];
}

- (void)displayLayer:(CALayer *)layer
{
    if (layer) {
        __weak typeof(self) weakSelf = self;
        [self _displayLayer:(PPAsyncDrawingViewLayer *)layer rect:layer.bounds drawingStarted:^(BOOL async) {
            [weakSelf drawingWillStartAsynchronously:async];
        } drawingFinished:^(BOOL async) {
            [weakSelf drawingDidFinishAsynchronously:async success:YES];
        } drawingInterrupted:^(BOOL async) {
            [weakSelf drawingDidFinishAsynchronously:async success:NO];
        }];
    }
}

- (void)drawingWillStartAsynchronously:(BOOL)async { }

- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success { }

- (void)_displayLayer:(PPAsyncDrawingViewLayer *)layer rect:(CGRect)rect drawingStarted:(void (^)(BOOL))drawingStarted drawingFinished:(void (^)(BOOL))drawingFinished drawingInterrupted:(void (^)(BOOL))drawingInterrupted
{
    BOOL asynchronously = NO;
    if ([layer drawsCurrentContentAsynchronously] && [PPAsyncDrawingView globallyAsyncDrawingEnabled]) {
        asynchronously = YES;
    }
    
    [layer increaseDrawingCount];
    NSInteger drawCount = [layer drawingCount];
    NSDictionary *userInfo = [self currentDrawingUserInfo];
    
    void (^drawingContents)() = ^(void) {
        if (drawCount != [layer drawingCount]) {
            drawingInterrupted(asynchronously);
            return;
        }
        CGSize size = layer.bounds.size;
        CGFloat scale = layer.contentsScale;
        BOOL isOpaque = layer.isOpaque;
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        if (drawCount != [layer drawingCount]) {
            CGContextRestoreGState(context);
            UIGraphicsEndImageContext();
            drawingInterrupted(asynchronously);
            return;
        }
        UIColor *backgroundColor = self.backgroundColor;
        if (backgroundColor) {
            if (backgroundColor != [UIColor clearColor]) {
                CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
                CGContextFillRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
            }
        }
        BOOL drawingSuccess = [self drawInRect:CGRectMake(0, 0, size.width, size.height)
                                   withContext:context asynchronously:asynchronously
                                      userInfo:userInfo];
        
        CGContextRestoreGState(context);
        if (!drawingSuccess) {
            UIGraphicsEndImageContext();
            drawingInterrupted(asynchronously);
            return;
        }
        if (drawCount != [layer drawingCount]) {
            UIGraphicsEndImageContext();
            drawingInterrupted(asynchronously);
            return;
        }
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *image;
        if (imageRef) {
            image = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
        }
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (drawCount != [layer drawingCount]) {
                drawingInterrupted(asynchronously);
                return;
            }
            layer.contents = (__bridge id _Nullable)(image.CGImage);
            layer.contentsChangedAfterLastAsyncDrawing = NO;
            layer.reserveContentsBeforeNextDrawingComplete = NO;

            if (layer.fadeDuration > 0) {
                layer.opacity = 0.0f;
                [UIView animateWithDuration:layer.fadeDuration delay:0 options:kNilOptions animations:^{
                    layer.opacity = 1.0f;
                } completion:nil];
            }
            drawingFinished(asynchronously);
        });
    };
    
    drawingStarted(asynchronously);
    if (asynchronously) {
        if (!layer.reserveContentsBeforeNextDrawingComplete) {
            layer.contents = nil;
        }
        dispatch_async(self.drawQueue, drawingContents);
    } else {
        if ([NSThread isMainThread]) {
            drawingContents();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.serializesDrawingOperations) {
                    dispatch_sync(self.drawQueue, ^{
                        drawingContents();
                    });
                } else {
                    drawingContents();
                }
            });
        }
    }
}

- (void)redraw
{
    [self displayLayer:self.layer];
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async
{
    return YES;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(NSDictionary *)userInfo
{
    return [self drawInRect:rect withContext:context asynchronously:async];
}

- (void)interruptDrawingWhenPossible
{
    [self.drawingLayer increaseDrawingCount];
}



- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (!self.alwaysUsesOffscreenRendering) {
        if ([NSStringFromSelector(aSelector) isEqual:@"displayLayer:"]) {
            if (self.drawingPolicy != PPAsyncDrawingTypeSync) {
                return YES;
            }
            return NO;
        } else {
            return [super respondsToSelector:aSelector];
        }
    } else {
        return [super respondsToSelector:aSelector];
    }
}

- (void)dealloc
{
    if (_dispatchDrawQueue) {
        _dispatchDrawQueue = nil;
    }
}

#pragma mark - getter and setter
+ (BOOL)globallyAsyncDrawingEnabled
{
    return asyncDrawingEnabled;
}

+ (void)setGloballyAsyncDrawingEnabled:(BOOL)globallyAsyncDrawingEnabled
{
    asyncDrawingEnabled = globallyAsyncDrawingEnabled;
}

- (PPAsyncDrawingViewLayer *)drawingLayer
{
    return (PPAsyncDrawingViewLayer *)self.layer;
}

- (NSTimeInterval)fadeDuration
{
    return self.drawingLayer.fadeDuration;
}

- (void)setFadeDuration:(NSTimeInterval)fadeDuration
{
    [self.drawingLayer setFadeDuration:fadeDuration];
}

- (BOOL)reserveContentsBeforeNextDrawingComplete
{
    return self.drawingLayer.reserveContentsBeforeNextDrawingComplete;
}

- (void)setReserveContentsBeforeNextDrawingComplete:(BOOL)reserveContentsBeforeNextDrawingComplete
{
    [self.drawingLayer setReserveContentsBeforeNextDrawingComplete:reserveContentsBeforeNextDrawingComplete];
}

- (BOOL)contentsChangedAfterLastAsyncDrawing
{
    return self.drawingLayer.contentsChangedAfterLastAsyncDrawing;
}

- (void)setContentsChangedAfterLastAsyncDrawing:(BOOL)contentsChangedAfterLastAsyncDrawing
{
    [self.drawingLayer setContentsChangedAfterLastAsyncDrawing:contentsChangedAfterLastAsyncDrawing];
}

- (PPAsyncDrawingType)drawingPolicy
{
    return self.drawingLayer.drawingPolicy;
}

- (void)setDrawingPolicy:(PPAsyncDrawingType)drawingPolicy
{
    [self.drawingLayer setDrawingPolicy:drawingPolicy];
}

- (NSUInteger)drawingCount
{
    return self.drawingLayer.drawingCount;
}

- (void)setDispatchDrawQueue:(dispatch_queue_t)dispatchDrawQueue
{
    if (!self.serializesDrawingOperations) {
        [self _setDispatchDrawQueue:dispatchDrawQueue];
    }
}

- (void)_setDispatchDrawQueue:(dispatch_queue_t)dispatchDrawQueue
{
    if (self.dispatchDrawQueue) {
        self.dispatchDrawQueue = nil;
    }
    self.dispatchDrawQueue = dispatchDrawQueue;
}

- (void)setSerializesDrawingOperations:(BOOL)serializesDrawingOperations
{
    if (_serializesDrawingOperations == serializesDrawingOperations) {
        return;
    }
    
    _serializesDrawingOperations = serializesDrawingOperations;
    if (serializesDrawingOperations) {
        dispatch_queue_t queue = dispatch_queue_create("PPAsyncDrawingViewSerializeQueue", 0);
        dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
        [self _setDispatchDrawQueue:queue];
    }
}

- (dispatch_queue_t)drawQueue
{
    if (self.dispatchDrawQueue) {
        return self.dispatchDrawQueue;
    } else {
        return dispatch_get_global_queue(self.dispatchPriority, 0);
    }
}

- (BOOL)alwaysUsesOffscreenRendering
{
    return YES;
}

@end

@implementation PPAsyncDrawingViewLayer

- (void)increaseDrawingCount
{
    OSAtomicIncrement32(&_drawingCount);
}

- (void)setNeedsDisplay
{
    [self increaseDrawingCount];
    [super setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect
{
    [self increaseDrawingCount];
    [super setNeedsDisplayInRect:rect];
}

- (BOOL)drawsCurrentContentAsynchronously
{
    if (_drawingPolicy == PPAsyncDrawingTypeAsync) {
        return YES;
    } else if (_drawingPolicy == PPAsyncDrawingTypeSync) {
        return NO;
    } else {
        return self.contentsChangedAfterLastAsyncDrawing;
    }
}

@end

