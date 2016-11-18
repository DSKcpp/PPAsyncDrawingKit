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

@interface WBTimelineTextContentView () <PPTextRendererDelegate, PPTextRendererEventDelegate>

@end

@implementation WBTimelineTextContentView

+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext userInfo:(NSDictionary *)userInfo
{
    CGFloat maxWidth = drawingContext.contentWidth - 12.0f * 2.0f;
    drawingContext.screenNameFrame = CGRectMake(51, 12, 100, 33);
    CGSize size = [drawingContext.itemAttributedText.attributedString pp_sizeConstrainedToWidth:maxWidth numberOfLines:0];
    size.height += 81;
    if (drawingContext.briefQuotedItemText) {
        CGFloat height = [drawingContext.quotedItemAttributedText.attributedString pp_heightConstrainedToWidth:maxWidth];
        drawingContext.quotedItemTextFrame = CGRectMake(0, size.height, drawingContext.contentWidth, height + 12);
        size = CGSizeMake(size.width, size.height + height + 12);
    }
    WBTimelineContentImageViewLayouter *imageLayouter = [[WBTimelineContentImageViewLayouter alloc] init];
    imageLayouter.constraintWidth = drawingContext.contentWidth;
    imageLayouter.horizonSpacing = 2.5;
    imageLayouter.verticalSpacing = 2.5;
    imageLayouter.needRelayout = YES;
    drawingContext.imageLayouter = imageLayouter;
    NSUInteger picCount = drawingContext.timelineItem.pic_infos.count;
    if (picCount == 0) {
        drawingContext.rectOfPhotoImage = CGRectZero;
    } else if (picCount == 1) {
        drawingContext.rectOfPhotoImage = CGRectMake(12, size.height, 148, 196);
        size.height += 196;
    } else {
        CGFloat wh = (maxWidth - 2.5 * 2) / 3;
        drawingContext.rectOfPhotoImage = CGRectMake(12, size.height, maxWidth, picCount % 3 * wh);
        size.height += (picCount / 3 + 1) * wh;
    }
    drawingContext.itemTextFrame = CGRectMake(0, 10, drawingContext.contentWidth, size.height - 10);
    size.height += 34;
    drawingContext.contentHeight = MAX(size.height, 136);
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
    WBTimelineItem *timelineItem = userInfo[@"timelineItem"];
    NSUInteger drawingCount = self.drawingCount;
    rect.size.width -= 24.0f;
    rect.origin.x = 62;
    rect.origin.y = 37;
    [self drawMetaInfoWithTimelineItem:timelineItem InRect:rect withContext:context initialDrawingCount:drawingCount];
    CGFloat y = self.metaInfoTextRenderer.textLayout.layoutHeight + 23;
    rect.origin.x = 12;
    rect.origin.y = 61;
    self.itemTextRenderer.frame = rect;
    self.itemTextRenderer.attributedString = [[NSAttributedString alloc] initWithString:timelineItem.text];
    [self.itemTextRenderer drawInContext:context shouldInterruptBlock:nil];
    if (timelineItem.retweeted_status.text) {
        CGFloat y = self.itemTextRenderer.textLayout.layoutHeight;
        rect.origin.y += y + 12;
        self.quotedItemTextRenderer.frame = rect;
        self.quotedItemTextRenderer.attributedString = [[NSAttributedString alloc] initWithString:timelineItem.retweeted_status.text];
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

- (void)drawMetaInfoWithTimelineItem:(WBTimelineItem *)timelineItem InRect:(CGRect)rect withContext:(CGContextRef)context initialDrawingCount:(NSUInteger)drawingCount
{
    [self setupMetaInfoRenderer:self.metaInfoTextRenderer timelineItem:timelineItem];
    self.metaInfoTextRenderer.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    [self.metaInfoTextRenderer drawInContext:context shouldInterruptBlock:nil];
}

- (void)setupMetaInfoRenderer:(PPTextRenderer *)metaInfoRenderer timelineItem:(WBTimelineItem *)timelineItem
{
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"2分钟前  来自iPhone 8"];
    self.metaInfoTextRenderer.attributedString = [[NSAttributedString alloc] initWithString:@"2分钟前  来自iPhone 8"];
    
//    if (self.drawingContext.shouldShowTime) {
//        NSString *displayTimeText = [self.drawingContext.timelineItem displayTimeText];
//        if (!displayTimeText) {
//            displayTimeText = @"";
//        }
//        
//    }
}
@end
