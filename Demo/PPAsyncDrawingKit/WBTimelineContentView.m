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
#import "WBTimelineScreenNameLabel.h"
#import "PPImageView.h"
#import "WBTimelineItem.h"
#import "WBTimelineActionButtonsView.h"
#import "UIView+Frame.h"
#import "WBColorImageView.h"
#import "UIImage+Color.h"
#import "WBTimelineImageContentView.h"
#import "PPImageView+WebCache.h"
#import "WBTimelinePreset.h"

@implementation WBTimelineContentView
+ (CGFloat)heightOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width
{
    WBTimelineTableViewCellDrawingContext *context = [self validDrawingContextOfTimelineItem:timelineItem withContentWidth:width];
    return context.rowHeight;
}

+ (void)calculateContentHeightForDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext
{
    [WBTimelineTextContentView renderDrawingContext:drawingContext];
    drawingContext.rowHeight = drawingContext.contentHeight;
}

+ (WBTimelineTableViewCellDrawingContext *)validDrawingContextOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width
{
    if (!timelineItem.drawingContext) {
        WBTimelineTableViewCellDrawingContext *drawingContext = [[WBTimelineTableViewCellDrawingContext alloc] initWithTimelineItem:timelineItem];
        drawingContext.contentWidth = width;
        [self calculateContentHeightForDrawingContext:drawingContext];
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
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    [self createTitleItemContentBackgroundView];
    [self createItemContentBackgroundView];
    [self createTextContentView];
    [self createNicknameLabel];
    [self createAvatarView];
    [self createActionButtonsView];
    [self createPhotoImageView];
}

- (void)createTitleItemContentBackgroundView
{
    self.itemTypeBgImageView = [[WBColorImageView alloc] init];
    self.itemTypeBgImageView.userInteractionEnabled = YES;
    [self.itemTypeBgImageView setBackgroundColor:[UIColor whiteColor] boolOwn:YES];
    [self addSubview:self.itemTypeBgImageView];
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    
    self.titleIcon = [[PPImageView alloc] initWithFrame:CGRectMake(preset.titleIconLeft, preset.titleIconTop, preset.titleIconSize, preset.titleIconSize)];
    self.titleIcon.image = [UIImage imageNamed:@"timeline_title_promotions"];
    [self addSubview:self.titleIcon];
}

- (void)createItemContentBackgroundView
{
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
}

- (void)createNicknameLabel
{
    self.nameLabel = [[WBTimelineScreenNameLabel alloc] initWithFrame:CGRectZero];
    [self insertSubview:self.nameLabel belowSubview:self.textContentView];
}

- (void)createTextContentView
{
    self.textContentView = [[WBTimelineTextContentView alloc] init];
    self.textContentView.enableAsyncDrawing = YES;
    [self addSubview:self.textContentView];
}

- (void)createAvatarView
{
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    self.avatarView = [[PPImageView alloc] initWithFrame:CGRectMake(preset.leftSpacing, 0, preset.avatarSize, preset.avatarSize)];
    self.avatarView.cornerRadius = preset.avatarCornerRadius;
    [self addSubview:self.avatarView];
}

- (void)createActionButtonsView
{
    CGFloat height = [WBTimelinePreset sharedInstance].actionButtonsHeight;
    self.actionButtonsView = [[WBTimelineActionButtonsView alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
    [self addSubview:self.actionButtonsView];
}

- (void)createPhotoImageView
{
    self.photoImageView = [[WBTimelineImageContentView alloc] init];
    [self addSubview:self.photoImageView];
}

- (void)setTimelineItem:(WBTimelineItem *)timelineItem
{
    if (_timelineItem != timelineItem) {
        _timelineItem = timelineItem;
        WBTimelineTableViewCellDrawingContext *drawingContext = timelineItem.drawingContext;
        self.frame = CGRectMake(0, 10, self.frame.size.width, drawingContext.contentHeight);
        self.itemTypeBgImageView.frame = drawingContext.titleBackgroundViewFrame;
        self.nameLabel.user = timelineItem.user;
        self.nameLabel.frame = drawingContext.nicknameFrame;
        self.textContentView.drawingContext = drawingContext;
        self.textContentView.frame = CGRectMake(0, 0, drawingContext.contentWidth, drawingContext.contentHeight);
        self.itemContentBgImageView.frame = drawingContext.textContentBackgroundViewFrame;
        self.itemContentBgImageView.bottomLineView.bottom = self.itemContentBgImageView.height;
        self.actionButtonsView.bottom = drawingContext.contentHeight;
        self.actionButtonsView.frame = drawingContext.actionButtonsViewFrame;
        self.photoImageView.frame = drawingContext.photoFrame;
        self.photoImageView.pictures = timelineItem.pic_infos.allValues;
        self.avatarView.frame = drawingContext.avatarFrame;
        self.quotedItemBorderButton.frame = drawingContext.quotedContentBackgroundViewFrame;
        NSString *url = timelineItem.user.avatar_large;
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"avatar"]];
        [self.actionButtonsView setTimelineItem:timelineItem];
    }
}
@end
