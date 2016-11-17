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
#import "WBTimelineItem.h"
#import "WBTimelineActionButtonsView.h"
#import "UIView+Frame.h"
#import "WBColorImageView.h"
#import "UIImage+Color.h"
#import "WBTimelineImageContentView.h"
#import "PPImageView+WebCache.h"

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
    if (!timelineItem.drawingContext) {
        WBTimelineTableViewCellDrawingContext *drawingContext = [[WBTimelineTableViewCellDrawingContext alloc] initWithTimelineItem:timelineItem];
        drawingContext.contentWidth = width;
        [self calculateContentHeightForDrawingContext:drawingContext userInfo:userInfo];
        timelineItem.drawingContext = drawingContext;
    }
    return timelineItem.drawingContext;
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
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5f)];
        topLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5f)];
        bottomLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        self.itemContentBgImageView = [[WBColorImageView alloc] init];
        self.itemContentBgImageView.userInteractionEnabled = YES;
        [self.itemContentBgImageView setBackgroundColor:[UIColor whiteColor] boolOwn:YES];
        self.itemContentBgImageView.highLightBackgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
        self.itemContentBgImageView.topLineView = topLineView;
        self.itemContentBgImageView.bottomLineView = bottomLineView;
        [self.itemContentBgImageView addSubview:topLineView];
        [self.itemContentBgImageView addSubview:bottomLineView];
        [self addSubview:self.itemContentBgImageView];
        
        self.quotedItemBorderButton = [[UIButton alloc] init];
        [self.quotedItemBorderButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]] forState:UIControlStateNormal];
        [self.quotedItemBorderButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]] forState:UIControlStateHighlighted];
        [self addSubview:self.quotedItemBorderButton];
        
        self.textContentView = [[WBTimelineTextContentView alloc] init];
        self.textContentView.enableAsyncDrawing = YES;
        [self addSubview:self.textContentView];
//        self.nameLabel = [[PPNameLabel alloc] initWithFrame:CGRectZero];
//        [self insertSubview:self.nameLabel belowSubview:self.textContentView];
        self.avatarView = [[PPImageView alloc] initWithFrame:CGRectMake(12, 25, 39, 39)];
        self.avatarView.cornerRadius = 19.5;
        [self addSubview:self.avatarView];
        
        self.actionButtonsView = [[WBTimelineActionButtonsView alloc] initWithFrame:CGRectMake(0, 0, width, 34)];
        [self addSubview:self.actionButtonsView];
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
        _timelineItem = timelineItem;
        WBTimelineTableViewCellDrawingContext *drawingContext = timelineItem.drawingContext;
        self.textContentView.drawingContext = drawingContext;
        self.textContentView.frame = CGRectMake(0, 10, drawingContext.contentWidth, drawingContext.contentHeight);
        self.itemContentBgImageView.frame = drawingContext.itemTextFrame;
        self.quotedItemBorderButton.frame = drawingContext.quotedItemTextFrame;
        self.actionButtonsView.bottom = drawingContext.contentHeight;
        self.itemContentBgImageView.bottomLineView.bottom = self.itemContentBgImageView.height;
        NSString *url = timelineItem.user.avatar_large;
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"avatar"]];
    }

}
@end
