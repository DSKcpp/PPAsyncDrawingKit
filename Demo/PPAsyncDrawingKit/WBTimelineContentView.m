//
//  WBTimelineContentView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineContentView.h"
#import "WBTimelineTableViewCellDrawingContext.h"
#import "WBTimelineTextContentView.h"

@implementation WBTimelineContentView
+ (CGFloat)heightOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width
{
    return [self heightOfTimelineItem:timelineItem withContentWidth:width userInfo:nil];
}

+ (CGFloat)heightOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width userInfo:(NSDictionary *)userInfo
{
    WBTimelineTableViewCellDrawingContext *context = [self validDrawingContextOfTimelineItem:timelineItem withContentWidth:width userInfo:userInfo];
    return context.rowHeight;
}

+ (void)calculateContentHeightForDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext userInfo:(NSDictionary *)userInfo
{
    [WBTimelineTextContentView renderDrawingContext:drawingContext userInfo:userInfo];
    drawingContext.rowHeight = drawingContext.contentHeight;
}

+ (WBTimelineTableViewCellDrawingContext *)validDrawingContextOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width userInfo:(NSDictionary *)userInfo
{
    WBTimelineTableViewCellDrawingContext *drawingContext = [[WBTimelineTableViewCellDrawingContext alloc] initWithTimelineItem:timelineItem];
    [self calculateContentHeightForDrawingContext:drawingContext userInfo:userInfo];
    return drawingContext;
}

- (instancetype)initWithWidth:(CGFloat)width
{
    return [self initWithFrame:CGRectMake(0, 0, width, 0)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textContentView = [[WBTimelineTextContentView alloc] init];
        [self addSubview:self.textContentView];
    }
    return self;
}

- (void)setTimelineItem:(WBTimelineItem *)timelineItem
{
    [self setTimelineItem:timelineItem userInfo:nil];
}

- (void)setTimelineItem:(WBTimelineItem *)timelineItem userInfo:(NSDictionary *)userInfo
{
    if (_timelineItem != timelineItem) {
        
    }
}
@end
