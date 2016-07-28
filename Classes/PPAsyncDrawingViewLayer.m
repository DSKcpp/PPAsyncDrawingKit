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

- (void)setNeedsDisplayInRect:(CGRect)r
{
    [self increaseDrawingCount];
    [super setNeedsDisplayInRect:r];
}

- (BOOL)drawsCurrentContentAsynchronously
{
    if (_drawingPolicy != 2) {
        if (_drawingPolicy == 0) {
            return _contentsChangedAfterLastAsyncDrawing;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

@end
