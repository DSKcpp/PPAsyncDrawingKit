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

@protocol WBTimelineTextContentViewDelegate <NSObject>
- (void)textContentView:(WBTimelineTextContentView *)textContentView didPressHighlightRange:(PPTextHighlightRange *)highlightRange;
@end

@interface WBTimelineTextContentView : PPMultiplexTextView
@property (nonatomic, strong) NSMutableArray *attachmentViews;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) WBTimelineLargeCardView *largeCardView;
@property (nonatomic, strong) PPTextLayout *sourceTextLayout;
@property (nonatomic, strong) PPTextLayout *titleTextLayout;
@property (nonatomic, strong) PPTextLayout *contentTextLayout;
@property (nonatomic, strong) PPTextLayout *quotedTextLayout;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) WBTimelineTableViewCellDrawingContext *drawingContext;
@property (nonatomic, weak) id<WBTimelineTextContentViewDelegate> delegate;

+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext;
- (void)setDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext;
@end
