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
#import "PPNameLabel.h"
#import "PPImageView.h"

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
    if (self = [self initWithFrame:CGRectMake(0, 0, width, 0)]) {
        self.contentWidth = width;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textContentView = [[WBTimelineTextContentView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        
        self.textContentView.enableAsyncDrawing = YES;
        [self addSubview:self.textContentView];
//        self.nameLabel = [[PPNameLabel alloc] initWithFrame:CGRectZero];
//        [self insertSubview:self.nameLabel belowSubview:self.textContentView];
        self.avatarView = [[PPImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
        self.avatarView.image = [UIImage imageNamed:@"avatar"];
        self.avatarView.cornerRadius = 19;
        [self addSubview:self.avatarView];
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
       WBTimelineTableViewCellDrawingContext *drawingContext = [WBTimelineContentView validDrawingContextOfTimelineItem:timelineItem withContentWidth:320 userInfo:userInfo];
        [self.textContentView setDrawingContext:drawingContext];
    }
}
@end
