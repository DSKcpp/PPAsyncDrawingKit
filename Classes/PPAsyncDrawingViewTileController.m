//
//  PPAsyncDrawingViewTileController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/7/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingViewTileController.h"
#import "PPAsyncDrawingView.h"
#import "PPAsyncDrawingViewLayer.h"
#import "PPAsyncDrawingViewTileLayer.h"

@implementation PPAsyncDrawingViewTileController

- (instancetype)init
{
    if (self = [super init]) {
        self.tilesQueue = [NSMutableSet set];
    }
    return self;
}

- (instancetype)initWithAsyncDrawingView:(PPAsyncDrawingView *)asyncDrawingView
{
    if (self = [self init]) {
        self.asyncDrawingView = asyncDrawingView;
        self.rootLayer = asyncDrawingView.drawingLayer;
    }
    return self;
}

- (void)cleanup {
    
}

- (void)enqueueTileLayer:(PPAsyncDrawingViewTileLayer *)asyncDrawingViewTileLayer
{
    if (asyncDrawingViewTileLayer) {
        [_tilesQueue addObject:asyncDrawingViewTileLayer];
    }
}

- (id)dequeueTileLayer
{
    PPAsyncDrawingViewTileLayer *layer = [_tilesQueue anyObject];
    if (layer) {
        [_tilesQueue removeObject:layer];
    } else  {
        layer = [PPAsyncDrawingViewTileLayer layer];
    }
    layer.asyncDrawingView = self.asyncDrawingView;
    layer.anchorPoint = CGPointZero;
    layer.bounds = CGRectZero;
    layer.position = CGPointZero;
    layer.edgeAntialiasingMask = 0;
    layer.opaque = NO;
    layer.contentsScale = self.rootLayer.contentsScale;
    [layer setNeedsDisplay];
    return layer;
}

- (void)setNeedsDisplayInRect:(CGRect)rect
{
    
}

- (void)setNeedsDisplay
{
    
}

- (void)revalidateTiles
{
    
}

- (void)setNeedsRevalidateTiles
{
    
}

- (void)boundsChanged
{
    
}

- (CGRect)rectForTileIndex:(NSInteger)index
{
    return CGRectZero;
}

- (void)updateTileLayerProperties
{
    
}

@end
