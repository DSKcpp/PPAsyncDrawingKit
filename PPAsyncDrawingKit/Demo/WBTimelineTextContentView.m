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
#import "NSAttributedString+PPExtendedAttributedString.h"
#import "WBTimelineAttributedTextParser.h"
#import "WBHelper.h"

@implementation WBTimelineTextContentView

+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext
{
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    CGFloat maxWidth = drawingContext.contentWidth - preset.leftSpacing * 2.0f;
    CGFloat totalHeight = 0.0f;
    
    if (drawingContext.hasTitle) {
        drawingContext.titleBackgroundViewFrame = CGRectMake(0, 0, drawingContext.contentWidth, preset.titleAreaHeight);
        CGFloat height = [drawingContext.titleAttributedText pp_heightConstrainedToWidth:maxWidth];
        CGRect titleRect = CGRectMake(preset.titleIconLeft + preset.titleIconSize + 5.0f, 0, maxWidth, height);
        titleRect.origin.y = (preset.titleAreaHeight - height) / 2.0f;
        drawingContext.titleFrame = titleRect;
        totalHeight += preset.titleAreaHeight;
    }
    
    CGFloat titleHeight = drawingContext.hasTitle ? preset.titleAreaHeight : 0;
    drawingContext.avatarFrame = CGRectMake(preset.leftSpacing, preset.avatarTop + titleHeight, preset.avatarSize, preset.avatarSize);
    
    CGFloat avatarMaxWidth = maxWidth - preset.avatarSize - preset.leftSpacing;
    
    drawingContext.nicknameFrame = CGRectMake(preset.nicknameLeft, totalHeight + preset.nicknameTop, avatarMaxWidth, 20);
    
    drawingContext.metaInfoFrame = CGRectMake(preset.nicknameLeft, preset.avatarSize + titleHeight, avatarMaxWidth, 20.0f);
    totalHeight += preset.headerAreaHeight;
    
    NSInteger numberOfLines = drawingContext.timelineItem.isLongText ? preset.numberOfLines : 0;
    CGFloat height = [drawingContext.textAttributedText pp_sizeConstrainedToWidth:maxWidth numberOfLines:numberOfLines].height;
    drawingContext.textFrame = CGRectMake(preset.leftSpacing, totalHeight, maxWidth, height);
    totalHeight += height;
    
    if (drawingContext.hasQuoted) {
        CGFloat qouteHeight = 0;
        NSInteger numberOfLines = drawingContext.timelineItem.retweeted_status.isLongText ? preset.numberOfLines : 0;
        CGFloat height = [drawingContext.quotedAttributedText pp_sizeConstrainedToWidth:maxWidth numberOfLines:numberOfLines].height;
        drawingContext.quotedFrame = CGRectMake(preset.leftSpacing, CGRectGetMaxY(drawingContext.textFrame) + preset.defaultMargin, maxWidth, height);
        qouteHeight += height + preset.defaultMargin;
        totalHeight += height + preset.defaultMargin;
        
        NSUInteger picCount = drawingContext.timelineItem.retweeted_status.pic_infos.count;
        if (picCount == 0) {
            drawingContext.photoFrame = CGRectZero;
        } else if (picCount == 1) {
            CGFloat width = preset.verticalImageWidth;
            CGFloat height = preset.verticalImageHeight;
            drawingContext.photoFrame = CGRectMake(preset.leftSpacing, totalHeight + preset.defaultMargin, width, height);
            qouteHeight += height + preset.defaultMargin;
            totalHeight += height + preset.defaultMargin;
        } else {
            NSUInteger rows = ceilf(picCount / 3.0f);
            CGFloat height = rows * preset.gridImageSize;
            drawingContext.photoFrame = CGRectMake(preset.leftSpacing, totalHeight + preset.defaultMargin, maxWidth, height);
            qouteHeight += height + preset.defaultMargin;
            totalHeight += height + preset.defaultMargin;
        }
        qouteHeight += preset.defaultMargin;
        totalHeight += preset.defaultMargin;
        drawingContext.quotedContentBackgroundViewFrame = CGRectMake(0, CGRectGetMinY(drawingContext.quotedFrame) - 5, drawingContext.contentWidth, qouteHeight + 5);
    } else {
        NSUInteger picCount = drawingContext.timelineItem.pic_infos.count;
        if (picCount == 0) {
            drawingContext.photoFrame = CGRectZero;
            totalHeight += preset.defaultMargin;
        } else if (picCount == 1) {
            CGFloat width = preset.verticalImageWidth;
            CGFloat height = preset.verticalImageHeight;
            drawingContext.photoFrame = CGRectMake(preset.leftSpacing, totalHeight + preset.defaultMargin, width, height);
            totalHeight += height + preset.defaultMargin * 2.0f;
        } else {
            NSUInteger rows = ceilf(picCount / 3.0f);
            CGFloat height = rows * preset.gridImageSize;
            drawingContext.photoFrame = CGRectMake(preset.leftSpacing, totalHeight + preset.defaultMargin, maxWidth, height);
            totalHeight += height + preset.defaultMargin * 2.0f;
        }
    }

    if (drawingContext.timelineItem.page_info) {
        if (drawingContext.hasQuoted) {
            CGRect rect = drawingContext.quotedContentBackgroundViewFrame;
            rect.size.height += preset.pageInfoHeight;
            drawingContext.quotedContentBackgroundViewFrame = rect;
        }
        drawingContext.largeFrame = CGRectMake(preset.leftSpacing, totalHeight, maxWidth, preset.pageInfoHeight);
        totalHeight += preset.pageInfoHeight + preset.defaultMargin;
    }
    
    drawingContext.textContentBackgroundViewFrame = CGRectMake(0, titleHeight, drawingContext.contentWidth, totalHeight - titleHeight);
    
    drawingContext.actionButtonsViewFrame = CGRectMake(0, CGRectGetMaxY(drawingContext.textContentBackgroundViewFrame), drawingContext.contentWidth, preset.actionButtonsHeight);
    totalHeight += preset.actionButtonsHeight + preset.defaultMargin;
    
    drawingContext.contentHeight = MAX(totalHeight, preset.minHeight);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        _contentTextLayout = [[PPTextLayout alloc] init];
        _quotedTextLayout = [[PPTextLayout alloc] init];
        _titleTextLayout = [[PPTextLayout alloc] init];
        _sourceTextLayout = [[PPTextLayout alloc] init];
        _sourceTextLayout.numberOfLines = 1;
        [self addTextLayout:_contentTextLayout];
        [self addTextLayout:_quotedTextLayout];
        [self addTextLayout:_titleTextLayout];
        [self addTextLayout:_sourceTextLayout];
        _largeCardView = [[WBTimelineLargeCardView alloc] initWithFrame:CGRectZero];
        [self addSubview:_largeCardView];
    }
    return self;
}

- (void)setDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext
{
    if (_drawingContext == drawingContext) {
        return;
    }
    
    _drawingContext = drawingContext;
    _largeCardView.frame = drawingContext.largeFrame;
    _largeCardView.pageInfo = drawingContext.timelineItem.page_info;
    self.hidden = YES;
    [self setNeedsDisplay];
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously
{
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    WBTimelineTableViewCellDrawingContext *drawingContext = self.drawingContext;
    if (drawingContext.hasTitle) {
        self.titleTextLayout.attributedString = drawingContext.titleAttributedText;
        CGRect rect = drawingContext.titleFrame;
        if (!drawingContext.timelineItem.title.icon_url) {
            rect.origin.x = preset.leftSpacing;
        }
        self.titleTextLayout.frame = rect;
        [self.titleTextLayout.textRenderer drawInContext:context];
    }
    
    self.sourceTextLayout.attributedString = drawingContext.metaInfoAttributedText;
    self.sourceTextLayout.frame = drawingContext.metaInfoFrame;
    [self.sourceTextLayout.textRenderer drawInContext:context];
    
    self.contentTextLayout.numberOfLines = drawingContext.timelineItem.isLongText ? preset.numberOfLines : 0;
    self.contentTextLayout.attributedString = drawingContext.textAttributedText;
    self.contentTextLayout.frame = drawingContext.textFrame;
    [self.contentTextLayout.textRenderer drawInContext:context];
    
    if (drawingContext.hasQuoted) {
        NSInteger numberOfLines = drawingContext.timelineItem.retweeted_status.isLongText ? preset.numberOfLines : 0;
        self.quotedTextLayout.numberOfLines = numberOfLines;
        self.quotedTextLayout.attributedString = drawingContext.quotedAttributedText;
        self.quotedTextLayout.frame = drawingContext.quotedFrame;
        [self.quotedTextLayout.textRenderer drawInContext:context];
    }
    return YES;
}

@end
