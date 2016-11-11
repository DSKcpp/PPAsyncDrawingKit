//
//  WBTimelineTextContentView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineTextContentView.h"
#import "WBTimelineTableViewCellDrawingContext.h"
#import "PPTextRenderer.h"
#import "WBCardsModel.h"

@interface WBTimelineTextContentView () <PPTextRendererDelegate, PPTextRendererEventDelegate>

@end

@implementation WBTimelineTextContentView

+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext userInfo:(NSDictionary *)userInfo
{
    drawingContext.contentHeight = 100;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.itemTextRenderer = [[PPTextRenderer alloc] init];
        self.itemTextRenderer.renderDelegate = self;
        self.itemTextRenderer.eventDelegate = self;
        self.quotedItemTextRenderer = [[PPTextRenderer alloc] init];
        self.quotedItemTextRenderer.renderDelegate = self;
        self.quotedItemTextRenderer.eventDelegate = self;
        self.titleTextRenderer = [[PPTextRenderer alloc] init];
        self.titleTextRenderer.renderDelegate = self;
        self.titleTextRenderer.eventDelegate = self;
        self.metaInfoTextRenderer = [[PPTextRenderer alloc] init];
        self.metaInfoTextRenderer.renderDelegate = self;
        self.metaInfoTextRenderer.eventDelegate = self;
        self.metaInfoTextRenderer.textLayout.maximumNumberOfLines = 1;
        self.attachmentViews = [NSMutableArray array];
        self.attachments = [NSMutableArray array];
        self.wb_accessibilityElements = [NSMutableArray array];
        self.dispatchPriority = 2;
        self.isSourceRectBeReset = NO;
    }
    return self;
}

- (void)setDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext
{
    _drawingContext = drawingContext;
}

- (void)drawingWillStartAsynchronously:(BOOL)async
{
    [self removeAttachmentViews];
}

- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success
{
    
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(NSDictionary *)userInfo
{
    WBTimelineTableViewCellDrawingContext *drawingContext = userInfo[@"drawingContext"];
    WBTimelineItem *timelineItem = userInfo[@"timelineItem"];
    NSUInteger drawingCount = self.drawingCount;
    [self drawMetaInfoWithTimelineItem:timelineItem InRect:rect withContext:context initialDrawingCount:drawingCount];
    self.itemTextRenderer.attributedString = [[NSAttributedString alloc] initWithString:timelineItem.text];
    
//    [self.itemTextRenderer drawInContext:context shouldInterruptBlock:nil];
    [self.itemTextRenderer drawInContext:context visibleRect:rect placeAttachments:YES shouldInterruptBlock:nil];
    if (timelineItem.retweeted_status.text) {
        self.quotedItemTextRenderer.attributedString = [[NSAttributedString alloc] initWithString:timelineItem.retweeted_status.text];
        [self.quotedItemTextRenderer drawInContext:context visibleRect:rect placeAttachments:YES shouldInterruptBlock:nil];
    }
    return YES;
}

- (NSDictionary *)currentDrawingUserInfo
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo pp_setSafeObject:self.drawingContext forKey:@"drawingContext"];
    [userInfo pp_setSafeObject:self.drawingContext.timelineItem forKey:@"timelineItem"];
    return userInfo;
}

- (void)removeAttachmentViews
{
    
}

- (void)addAttachmentViews
{
    
}

- (void)drawMetaInfoWithTimelineItem:(WBTimelineItem *)timelineItem InRect:(CGRect)rect withContext:(CGContextRef)context initialDrawingCount:(NSUInteger)drawingCount
{
    
}
@end
