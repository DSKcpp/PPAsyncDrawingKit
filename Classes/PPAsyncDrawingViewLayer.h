//
//  PPAsyncDrawingViewLayer.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPAsyncDrawingViewLayer : CALayer
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;
@property (nonatomic, assign) NSInteger drawingPolicy;
@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, assign, readonly) NSInteger drawingCount;

- (BOOL)drawsCurrentContentAsynchronously;
- (void)increaseDrawingCount;
@end

NS_ASSUME_NONNULL_END
