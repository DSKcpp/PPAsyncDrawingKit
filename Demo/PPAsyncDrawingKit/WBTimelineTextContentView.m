//
//  WBTimelineTextContentView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineTextContentView.h"
#import "PPTextRenderer.h"
#import "WBTimelineItem.h"
#import "NSAttributedString+PPAsyncDrawingKit.h"
#import "WBTimelineAttributedTextParser.h"
#import "PPTextActiveRange.h"
#import "WBHelper.h"

@interface WBTimelineTextContentView () <PPTextRendererDelegate>

@end

@implementation WBTimelineTextContentView

+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext
{
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    CGFloat maxWidth = drawingContext.contentWidth - preset.leftSpacing * 2.0f;
    CGFloat totalHeight = 0.0f;
    if (drawingContext.hasTitle) {
        drawingContext.titleBackgroundViewFrame = CGRectMake(0, 0, drawingContext.contentWidth, preset.titleAreaHeight);
        CGFloat height = [drawingContext.titleAttributedText pp_heightConstrainedToWidth:maxWidth];
        drawingContext.titleFrame = CGRectMake(preset.titleIconLeft + preset.titleIconSize + 5.0f, 6.0f, drawingContext.contentWidth, height);
        totalHeight += preset.titleAreaHeight;
    }
    CGFloat titleHeight = drawingContext.hasTitle ? preset.titleAreaHeight : 0;
    drawingContext.avatarFrame = CGRectMake(preset.leftSpacing, preset.avatarTop + titleHeight, preset.avatarSize, preset.avatarSize);
    drawingContext.nicknameFrame = CGRectMake(preset.nicknameLeft, totalHeight + preset.nicknameTop, 100, 20);
    drawingContext.metaInfoFrame = CGRectMake(preset.nicknameLeft, preset.avatarSize + titleHeight, drawingContext.contentWidth, 20.0f);
    totalHeight += preset.headerAreaHeight;
    
    CGFloat height = [drawingContext.textAttributedText pp_heightConstrainedToWidth:maxWidth];
    drawingContext.textFrame = CGRectMake(preset.leftSpacing, totalHeight, maxWidth, height);
    totalHeight += height;
    if (drawingContext.hasQuoted) {
        CGFloat qouteHeight = 0;
        CGFloat height = [drawingContext.quotedAttributedText pp_heightConstrainedToWidth:maxWidth];
        drawingContext.quotedFrame = CGRectMake(preset.leftSpacing, CGRectGetMaxY(drawingContext.textFrame) + 10, maxWidth, height);
        qouteHeight += height + 10;
        totalHeight += height + 10;
        
        NSUInteger picCount = drawingContext.timelineItem.retweeted_status.pic_infos.count;
        if (picCount == 0) {
            drawingContext.photoFrame = CGRectZero;
        } else if (picCount == 1) {
            CGFloat width = preset.verticalImageWidth;
            CGFloat height = preset.verticalImageHeight;
            drawingContext.photoFrame = CGRectMake(preset.leftSpacing, totalHeight + 10, width, height);
            qouteHeight += height + 10.0f;
            totalHeight += height + 10.0f;
        } else {
            NSUInteger rows = ceilf(picCount / 3.0f);
            CGFloat height = rows * preset.gridImageSize;
            drawingContext.photoFrame = CGRectMake(preset.leftSpacing, totalHeight + 10, maxWidth, height);
            qouteHeight += height + 10.0f;
            totalHeight += height + 10.0f;
        }
        qouteHeight += 10.0f;
        totalHeight += 10.0f;
        drawingContext.quotedContentBackgroundViewFrame = CGRectMake(0, CGRectGetMinY(drawingContext.quotedFrame) - 5, drawingContext.contentWidth, qouteHeight + 5);
    } else {
        NSUInteger picCount = drawingContext.timelineItem.pic_infos.count;
        if (picCount == 0) {
            drawingContext.photoFrame = CGRectZero;
            totalHeight += 10.0f;
        } else if (picCount == 1) {
            CGFloat width = preset.verticalImageWidth;
            CGFloat height = preset.verticalImageHeight;
            drawingContext.photoFrame = CGRectMake(preset.leftSpacing, totalHeight + 10, width, height);
            totalHeight += height + 20.0f;
        } else {
            NSUInteger rows = ceilf(picCount / 3.0f);
            CGFloat height = rows * preset.gridImageSize;
            drawingContext.photoFrame = CGRectMake(preset.leftSpacing, totalHeight + 10, maxWidth, height);
            totalHeight += height + 20.0f;
        }
    }

    if (drawingContext.timelineItem.page_info) {
//        drawingContext.largeFrame = CGRectMake(preset.leftSpacing, totalHeight, maxWidth, 71.0f);
//        totalHeight += 71.0f;
    }
    
    drawingContext.textContentBackgroundViewFrame = CGRectMake(0, titleHeight, drawingContext.contentWidth, totalHeight - titleHeight);
    drawingContext.actionButtonsViewFrame = CGRectMake(0, CGRectGetMaxY(drawingContext.textContentBackgroundViewFrame), drawingContext.contentWidth, preset.actionButtonsHeight);
    totalHeight += preset.actionButtonsHeight + 10.0f;
    drawingContext.contentHeight = MAX(totalHeight, 136.0f);
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
        self.dispatchPriority = 2;
        self.isSourceRectBeReset = NO;
        self.textRenderers = @[self.itemTextRenderer, self.quotedItemTextRenderer, self.titleTextRenderer, self.metaInfoTextRenderer];
        _largeCardView = [[WBTimelineLargeCardView alloc] initWithFrame:CGRectZero];
        [self addSubview:_largeCardView];
    }
    return self;
}

- (void)setDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext
{
    _drawingContext = drawingContext;
    self.contentsChangedAfterLastAsyncDrawing = YES;
    [self setNeedsDisplay];
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
    if (drawingContext.hasTitle) {
        self.titleTextRenderer.attributedString = drawingContext.titleAttributedText;
        self.titleTextRenderer.frame = drawingContext.titleFrame;
        [self.titleTextRenderer drawInContext:context shouldInterruptBlock:nil];
    }
    self.metaInfoTextRenderer.attributedString = drawingContext.metaInfoAttributedText;
    self.metaInfoTextRenderer.frame = drawingContext.metaInfoFrame;
    [self.metaInfoTextRenderer drawInContext:context shouldInterruptBlock:nil];
    self.itemTextRenderer.frame = drawingContext.textFrame;
    self.itemTextRenderer.attributedString = drawingContext.textAttributedText;
    [self.itemTextRenderer drawInContext:context shouldInterruptBlock:nil];
    if (drawingContext.hasQuoted) {
        self.quotedItemTextRenderer.frame = drawingContext.quotedFrame;
        self.quotedItemTextRenderer.attributedString = drawingContext.quotedAttributedText;
        [self.quotedItemTextRenderer drawInContext:context shouldInterruptBlock:nil];
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

- (void)textRenderer:(PPTextRenderer *)textRenderer didPressHighlightRange:(PPTextHighlightRange *)highlightRange
{
    if ([_delegate respondsToSelector:@selector(textContentView:didPressHighlightRange:)]) {
        [_delegate textContentView:self didPressHighlightRange:highlightRange];
    }
}

@end
