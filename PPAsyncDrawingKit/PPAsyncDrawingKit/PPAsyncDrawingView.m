//
//  PPAsyncDrawingView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"
#import <stdatomic.h>
#import "PPAssert.h"

dispatch_queue_t PPDrawConcurrentQueue(void) {
    static dispatch_queue_t queue;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        queue = dispatch_queue_create("io.github.dskcpp.drawQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

@interface _PPAsyncDrawingViewLayer : CALayer
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;

@property (nonatomic, assign) PPAsyncDrawingPolicy drawingPolicy;
@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, assign, readonly) atomic_uint drawingCount;

- (void)increaseDrawingCount;
- (BOOL)drawCurrentContentAsynchronously;
@end

@implementation _PPAsyncDrawingViewLayer

- (void)increaseDrawingCount
{
    atomic_fetch_add(&_drawingCount, 1);
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

- (BOOL)drawCurrentContentAsynchronously
{
    if (_drawingPolicy == PPAsyncDrawingPolicyMultiThread) {
        return YES;
    } else if (_drawingPolicy == PPAsyncDrawingPolicyMainThread) {
        return NO;
    } else {
        return self.contentsChangedAfterLastAsyncDrawing;
    }
}
@end

@implementation PPAsyncDrawingView
static BOOL asyncDrawingEnabled = YES;

+ (Class)layerClass
{
    return [_PPAsyncDrawingViewLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initializeInstance];
    }
    return self;
}

- (void)_initializeInstance
{
    self.drawingPolicy = PPAsyncDrawingPolicyNone;
    self.opaque = NO;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
}

- (NSDictionary *)currentDrawingUserInfo
{
    return nil;
}

#pragma mark - drawing
- (void)setNeedsDisplayAsync
{
    self.contentsChangedAfterLastAsyncDrawing = YES;
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
        [self _displayLayer:(_PPAsyncDrawingViewLayer *)layer rect:layer.bounds drawingStarted:^(BOOL async) {
            [weakSelf drawingWillStartAsynchronously:async];
        } drawingFinished:^(BOOL async) {
            [weakSelf drawingDidFinishAsynchronously:async success:YES];
        } drawingInterrupted:^(BOOL async) {
            [weakSelf drawingDidFinishAsynchronously:async success:NO];
        }];
    }
}

- (void)drawingWillStartAsynchronously:(BOOL)asynchronously { }

- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success { }

- (void)_displayLayer:(_PPAsyncDrawingViewLayer *)layer rect:(CGRect)rect drawingStarted:(void (^)(BOOL))drawingStarted drawingFinished:(void (^)(BOOL))drawingFinished drawingInterrupted:(void (^)(BOOL))drawingInterrupted
{
    BOOL asynchronously = NO;
    if ([layer drawCurrentContentAsynchronously] && [PPAsyncDrawingView globallyAsyncDrawingEnabled]) {
        asynchronously = YES;
    }
    
    [layer increaseDrawingCount];
    atomic_int drawCount = [layer drawingCount];
    NSDictionary *userInfo = [self currentDrawingUserInfo];
    
    BOOL (^needCancel)(void) = ^BOOL(void) {
        return drawCount != [layer drawingCount];
    };
    
    void (^drawingContents)() = ^(void) {
        if (needCancel()) {
            drawingInterrupted(asynchronously);
            return;
        }
        CGSize size = layer.bounds.size;
        CGFloat scale = layer.contentsScale;
        BOOL isOpaque = layer.isOpaque;
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        if (needCancel()) {
            CGContextRestoreGState(context);
            UIGraphicsEndImageContext();
            drawingInterrupted(asynchronously);
            return;
        }
        UIColor *backgroundColor = self.backgroundColor;
        if (backgroundColor && backgroundColor != [UIColor clearColor]) {
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextFillRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
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
        if (needCancel()) {
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
            if (needCancel()) {
                drawingInterrupted(asynchronously);
                return;
            }
            layer.contents = (__bridge id _Nullable)(image.CGImage);
            layer.reserveContentsBeforeNextDrawingComplete = NO;
            layer.contentsChangedAfterLastAsyncDrawing = NO;
            if (layer.fadeDuration > 0) {
                layer.opacity = 0.0f;
                [UIView animateWithDuration:layer.fadeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
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
        dispatch_async(self.internalDrawQueue, drawingContents);
    } else if ([NSThread isMainThread]) {
        drawingContents();
    } else {
        dispatch_async(dispatch_get_main_queue(), drawingContents);
    }
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async
{
    return YES;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(NSDictionary *)userInfo
{
    return [self drawInRect:rect withContext:context asynchronously:async];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (!self.alwaysUsesOffscreenRendering) {
        if ([NSStringFromSelector(aSelector) isEqual:@"displayLayer:"]) {
            if (self.drawingPolicy != PPAsyncDrawingPolicyMainThread) {
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

#pragma mark - getter and setter
+ (BOOL)globallyAsyncDrawingEnabled
{
    return asyncDrawingEnabled;
}

+ (void)setGloballyAsyncDrawingEnabled:(BOOL)globallyAsyncDrawingEnabled
{
    asyncDrawingEnabled = globallyAsyncDrawingEnabled;
}

- (_PPAsyncDrawingViewLayer *)drawingLayer
{
    return (_PPAsyncDrawingViewLayer *)self.layer;
}

- (NSTimeInterval)fadeDuration
{
    return self.drawingLayer.fadeDuration;
}

- (void)setFadeDuration:(NSTimeInterval)fadeDuration
{
    [self.drawingLayer setFadeDuration:fadeDuration];
}

- (BOOL)contentsChangedAfterLastAsyncDrawing
{
    return self.drawingLayer.contentsChangedAfterLastAsyncDrawing;
}

- (void)setContentsChangedAfterLastAsyncDrawing:(BOOL)contentsChangedAfterLastAsyncDrawing
{
    [self.drawingLayer setContentsChangedAfterLastAsyncDrawing:contentsChangedAfterLastAsyncDrawing];
}

- (BOOL)reserveContentsBeforeNextDrawingComplete
{
    return self.drawingLayer.reserveContentsBeforeNextDrawingComplete;
}

- (void)setReserveContentsBeforeNextDrawingComplete:(BOOL)reserveContentsBeforeNextDrawingComplete
{
    [self.drawingLayer setReserveContentsBeforeNextDrawingComplete:reserveContentsBeforeNextDrawingComplete];
}

- (PPAsyncDrawingPolicy)drawingPolicy
{
    return self.drawingLayer.drawingPolicy;
}

- (void)setDrawingPolicy:(PPAsyncDrawingPolicy)drawingPolicy
{
    [self.drawingLayer setDrawingPolicy:drawingPolicy];
}

- (NSUInteger)drawingCount
{
    return self.drawingLayer.drawingCount;
}

- (dispatch_queue_t)internalDrawQueue
{
    if (_drawQueue) {
        return _drawQueue;
    } else {
        return PPDrawConcurrentQueue();
    }
}

- (BOOL)alwaysUsesOffscreenRendering
{
    return YES;
}

@end
