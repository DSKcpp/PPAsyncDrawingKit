//
//  PPAsyncDrawingViewTileController.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/7/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PPAsyncDrawingViewLayer;
@class PPAsyncDrawingView;
@class PPAsyncDrawingViewTileLayer;

@interface PPAsyncDrawingViewTileController : NSObject
@property (nonatomic, strong) NSMutableSet *tilesQueue;
@property (nonatomic, weak) PPAsyncDrawingViewLayer *rootLayer;
@property (nonatomic ,weak) PPAsyncDrawingView *asyncDrawingView;
@property (nonatomic, assign) CGFloat tileHeight;
@property (nonatomic, assign) CGRect visibleRect;
@property (nonatomic, getter=tilesAreOpaque) BOOL tilesOpaque;

- (instancetype)initWithAsyncDrawingView:(PPAsyncDrawingView *)asyncDrawingView;
- (void)cleanup;
- (void)enqueueTileLayer:(PPAsyncDrawingViewTileLayer *)asyncDrawingViewTileLayer;
- (id)dequeueTileLayer;
- (void)setNeedsDisplayInRect:(CGRect)rect;
- (void)setNeedsDisplay;
- (void)revalidateTiles;
- (void)setNeedsRevalidateTiles;
- (void)boundsChanged;
- (CGRect)rectForTileIndex:(NSInteger)index;
- (void)updateTileLayerProperties;

@end
