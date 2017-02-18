//
//  WBTimelineTextContentView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"
#import "WBTimelineLargeCardView.h"
#import "PPMultiplexTextView.h"

@class WBTimelineItem;
@class WBTimelineTextContentView;

@interface WBTimelineTextContentView : PPMultiplexTextView
@property (nonatomic, strong, readonly) PPTextLayout *sourceTextLayout;
@property (nonatomic, strong, readonly) PPTextLayout *titleTextLayout;
@property (nonatomic, strong, readonly) PPTextLayout *contentTextLayout;
@property (nonatomic, strong, readonly) PPTextLayout *quotedTextLayout;
@property (nonatomic, strong, readonly) WBTimelineLargeCardView *largeCardView;
@property (nonatomic, strong) WBTimelineTableViewCellDrawingContext *drawingContext;
@property (nonatomic, assign) BOOL highlighted;

+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext;
@end
