//
//  PPAsyncDrawingViewLayer.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingViewLayer.h"

@implementation PPAsyncDrawingViewLayer

- (void)increaseDrawingCount
{
    _drawingCount += 1;
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
    if (_drawingPolicy != DISPATCH_QUEUE_PRIORITY_HIGH) {
        if (_drawingPolicy == DISPATCH_QUEUE_PRIORITY_DEFAULT) {
            return _contentsChangedAfterLastAsyncDrawing;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

@end
