//
//  WBTimelineContentView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTimelineItem.h"
#import "PPImageView.h"
#import "PPButton.h"

@class WBTimelineTableViewCellDrawingContext;
@class WBTimelineTextContentView;
@class WBTimelineScreenNameLabel;
@class WBTimelineActionButtonsView;
@class WBTimelineImageContentView;

@interface WBColorImageView : UIImageView
@property(retain, nonatomic) UIView *bottomLineView;
@property(retain, nonatomic) UIView *topLineView;
@property(retain, nonatomic) UIColor *commonBackgroundColor;
@property(retain, nonatomic) UIColor *highLightBackgroundColor;

- (void)setBackgroundColor:(UIColor *)backgroundColor boolOwn:(BOOL)boolOwn;
- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)setHighlighted:(BOOL)highlighted;
@end

@interface WBTimelineContentView : UIView
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@property (nonatomic, strong) PPImageView *avatarView;
@property (nonatomic, strong) WBTimelineScreenNameLabel *nameLabel;
@property (nonatomic, strong) WBTimelineTextContentView *textContentView;
@property (nonatomic, strong) WBTimelineActionButtonsView *actionButtonsView;
@property (nonatomic, strong) WBColorImageView *itemContentBgImageView;
@property (nonatomic, strong) UIButton *quotedItemBorderButton;
@property (nonatomic, strong) WBTimelineImageContentView *photoImageView;
@property (nonatomic, strong) WBColorImageView *itemTypeBgImageView;
@property (nonatomic, strong) PPImageView *titleIcon;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) CGFloat contentWidth;

+ (CGFloat)heightOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width;
+ (WBTimelineTableViewCellDrawingContext *)validDrawingContextOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width;
- (instancetype)initWithWidth:(CGFloat)width;
- (void)setTimelineItem:(WBTimelineItem *)timelineItem;
- (void)setSelectionColor:(BOOL)highlighted;
@end

@interface WBTimelineActionButtonsView : UIView
@property (nonatomic, strong, readonly) PPButton *retweetButton;
@property (nonatomic, strong, readonly) PPButton *commentButton;
@property (nonatomic, strong, readonly) PPButton *likeButton;
- (void)setTimelineItem:(WBTimelineItem *)timelineItem;
- (void)setButtonsHighlighted:(BOOL)highlighted;
@end
