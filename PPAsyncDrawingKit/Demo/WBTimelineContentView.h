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
#import "WBTimelineTextContentView.h"
#import "WBTimelineImageContentView.h"
#import "WBTimelineTableViewCell.h"

@interface WBNameLabel : PPTextView
@property (nonatomic, strong) WBUser *user;
@end

@interface WBColorImageView : UIImageView
@property(retain, nonatomic) UIView *bottomLineView;
@property(retain, nonatomic) UIView *topLineView;
@property(retain, nonatomic) UIColor *commonBackgroundColor;
@property(retain, nonatomic) UIColor *highLightBackgroundColor;

- (void)setBackgroundColor:(UIColor *)backgroundColor boolOwn:(BOOL)boolOwn;
- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)setHighlighted:(BOOL)highlighted;
@end

@interface WBTimelineActionButtonsView : UIView
@property (nonatomic, strong, readonly) PPButton *retweetButton;
@property (nonatomic, strong, readonly) PPButton *commentButton;
@property (nonatomic, strong, readonly) PPButton *likeButton;
- (void)setTimelineItem:(WBTimelineItem *)timelineItem;
- (void)setButtonsHighlighted:(BOOL)highlighted;
@end

@interface WBTimelineContentView : UIView
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@property (nonatomic, strong, readonly) PPImageView *avatarView;
@property (nonatomic, strong, readonly) WBNameLabel *nameLabel;
@property (nonatomic, strong, readonly) WBTimelineTextContentView *textContentView;
@property (nonatomic, strong, readonly) WBTimelineActionButtonsView *actionButtonsView;
@property (nonatomic, strong, readonly) WBColorImageView *titleBgImageView;
@property (nonatomic, strong, readonly) WBColorImageView *itemContentBgImageView;
@property (nonatomic, strong, readonly) UIButton *quotedItemBorderButton;
@property (nonatomic, strong, readonly) WBTimelineImageContentView *photoImageView;
@property (nonatomic, strong, readonly) PPImageView *titleIcon;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, weak) id<WBTimelineTableViewCellDelegate> delegate;
@property (nonatomic, weak) WBTimelineTableViewCell *cell;

+ (CGFloat)heightOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width;
+ (WBTimelineTableViewCellDrawingContext *)validDrawingContextOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width;
- (instancetype)initWithWidth:(CGFloat)width;
- (void)setTimelineItem:(WBTimelineItem *)timelineItem;
- (void)setSelectionColor:(BOOL)highlighted;
@end

