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
#import "WBTimelineItem.h"
#import "PPAttributedText.h"
#import "NSAttributedString+PPAsyncDrawingKit.h"
#import "WBTimelineContentImageViewLayouter.h"
#import "WBTimelinePreset.h"

@interface WBTimelineTextContentView () <PPTextRendererDelegate, PPTextRendererEventDelegate>

@end

@implementation WBTimelineTextContentView

+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext userInfo:(NSDictionary *)userInfo
{
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    CGFloat maxWidth = drawingContext.contentWidth - preset.leftSpacing * 2.0f;
    CGFloat totalHeight = 0.0f;
    if (drawingContext.hasTitle) {
        drawingContext.titleBackgroundViewFrame = CGRectMake(0, 0, drawingContext.contentWidth, preset.titleItemHeight);
        drawingContext.titleFrame = CGRectMake(preset.titleIconLeft + preset.titleIconSize + 5.0f, preset.titleIconTop, drawingContext.contentWidth, preset.titleItemHeight);
        totalHeight += preset.titleItemHeight;
    }
    
    CGFloat titleHeight = CGRectGetHeight(drawingContext.titleFrame);
    drawingContext.avatarFrame = CGRectMake(preset.leftSpacing, preset.avatarTop + titleHeight, preset.avatarSize, preset.avatarSize);
    drawingContext.nicknameFrame = CGRectMake(preset.nameLabelLeft, totalHeight + preset.nameLabelTop, 100, 20);
    drawingContext.metaInfoFrame = CGRectMake(preset.nameLabelLeft, 39.0f + titleHeight, drawingContext.contentWidth, 20.0f);
    totalHeight += 54.0f;
    
    CGFloat height = [drawingContext.textAttributedText.attributedString pp_heightConstrainedToWidth:maxWidth];
    drawingContext.textFrame = CGRectMake(preset.leftSpacing, totalHeight + 10.0f, maxWidth, height + 10.0f);
    totalHeight += height + 20.0f;
    
    if (drawingContext.hasQuoted) {
        CGFloat height = [drawingContext.quotedAttributedText.attributedString pp_heightConstrainedToWidth:maxWidth];
        drawingContext.quotedFrame = CGRectMake(preset.leftSpacing, CGRectGetMaxY(drawingContext.textFrame), maxWidth, height + 10);
        totalHeight += height + 10.0f;
        drawingContext.quotedContentBackgroundViewFrame = CGRectMake(0, CGRectGetMinY(drawingContext.quotedFrame) - 5.0f, drawingContext.contentWidth, CGRectGetHeight(drawingContext.quotedFrame) + 5.0f);
    }
    NSUInteger picCount = drawingContext.timelineItem.pic_infos.count;
    if (picCount == 0) {
        drawingContext.photoFrame = CGRectZero;
    } else if (picCount == 1) {
        CGFloat width = preset.oneImageWidth;
        CGFloat height = preset.oneImageHeight;
        drawingContext.photoFrame = CGRectMake(12, totalHeight, width, height);
        totalHeight += height + 10.0f;
    } else {
        NSUInteger rows = ceilf(picCount / 3.0f);
        CGFloat height = rows * preset.gridImageSize;
        drawingContext.photoFrame = CGRectMake(12, totalHeight, maxWidth, height);
        totalHeight += height + 10.0f;
    }
    drawingContext.textContentBackgroundViewFrame = CGRectMake(0, titleHeight, drawingContext.contentWidth, totalHeight - titleHeight);
    drawingContext.actionButtonsViewFrame = CGRectMake(0, CGRectGetMaxY(drawingContext.textContentBackgroundViewFrame), drawingContext.contentWidth, preset.actionButtonsHeight);
    totalHeight += preset.actionButtonsHeight + 10.0f;
    drawingContext.contentHeight = MAX(totalHeight, 136);
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
        self.contentsChangedAfterLastAsyncDrawing = YES;
    }
    return self;
}

- (void)setDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext
{
    _drawingContext = drawingContext;
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
        self.titleTextRenderer.attributedString = drawingContext.titleAttributedText.attributedString;
        self.titleTextRenderer.frame = drawingContext.titleFrame;
        [self.titleTextRenderer drawInContext:context shouldInterruptBlock:nil];
    }
    self.metaInfoTextRenderer.attributedString = [[NSAttributedString alloc] initWithString:@"2分钟前  来自iPhone 7"];
    self.metaInfoTextRenderer.frame = drawingContext.metaInfoFrame;
    [self.metaInfoTextRenderer drawInContext:context shouldInterruptBlock:nil];
    self.itemTextRenderer.frame = drawingContext.textFrame;
    self.itemTextRenderer.attributedString = drawingContext.textAttributedText.attributedString;
    [self.itemTextRenderer drawInContext:context shouldInterruptBlock:nil];
    if (drawingContext.hasQuoted) {
        self.quotedItemTextRenderer.frame = drawingContext.quotedFrame;
        self.quotedItemTextRenderer.attributedString = drawingContext.quotedAttributedText.attributedString;
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
@end
