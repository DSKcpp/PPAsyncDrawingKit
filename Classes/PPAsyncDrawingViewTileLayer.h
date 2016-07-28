//
//  PPAsyncDrawingViewTileLayer.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/7/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingViewLayer.h"

@class PPAsyncDrawingView;

@interface PPAsyncDrawingViewTileLayer : PPAsyncDrawingViewLayer
@property (nonatomic, weak) PPAsyncDrawingView *asyncDrawingView;
@property (nonatomic, assign) BOOL hasStaleContent;
@property (nonatomic ,assign) NSInteger index;

- (void)display;
- (id)actionForKey:(id)arg1;
@end
