//
//  WBTimelineActionButtonsView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBTimelineItem;
@class PPButton;

@interface WBTimelineActionButtonsView : UIView
+ (id)likedStatisticsWithParameters:(id)arg1 forStatus:(id)arg2;
+ (void)adClickeStatisticsWithActionCode:(id)arg1 status:(id)arg2;
+ (void)respondToLikeButton:(id)arg1 type:(unsigned long long)arg2 inView:(id)arg3 timelineItem:(id)arg4 delegate:(id)arg5;
+ (void)respondToForwardButton:(id)arg1 type:(unsigned long long)arg2 inView:(id)arg3 timelineItem:(id)arg4 delegate:(id)arg5;
+ (void)showForwardComposerWithStatus:(id)arg1 view:(id)arg2;
+ (void)respondToCommentButton:(id)arg1 type:(unsigned long long)arg2 inView:(id)arg3 timelineItem:(id)arg4 delegate:(id)arg5;
+ (void)showCommentComposerWithStatus:(id)arg1 view:(id)arg2;
@property(retain, nonatomic) NSArray *actionButtonTypes;
@property(nonatomic) long long buttonWidth;
@property(nonatomic) long long lineHeight;
@property(nonatomic) long long btnHeight;
@property(retain, nonatomic) UIFont *btnFont;
@property(retain, nonatomic) NSString *composeDefaultText;
@property(nonatomic) _Bool needsButtonSeparators;
@property(nonatomic) _Bool needsBackgroundImageForHighlightedState;
@property(nonatomic) _Bool ignoreTimelineItemShouldShowButtonsSetting;
@property(retain, nonatomic) WBTimelineItem *timelineItem;
@property (nonatomic, strong) NSArray<PPButton *> *actionButtons;
//@property(nonatomic) __weak id <WBTimelineActionButtonsViewDelegate> delegate; // @synthesize delegate=_delegate;
- (void)buttonAutoresizingMask:(id)arg1;
- (void)likeStatePostRequestCompletedNotification:(id)arg1;
- (id)peekViewControllerForActionButtonType:(unsigned long long)arg1;
- (id)previewingContext:(id)arg1 viewControllerForLocation:(struct CGPoint)arg2;
- (void)didPressShareButton:(id)arg1;
- (void)didPressLikeButton:(id)arg1 withType:(unsigned long long)arg2;
- (void)didPressCancelLikeAndFavoriteButton:(id)arg1;
- (void)didPressCancelLikeButton:(id)arg1;
- (void)didPressCancelFavoriteButton:(id)arg1;
- (void)didPressLikeButton:(id)arg1;
- (void)didPressForwardButton:(id)arg1 withType:(unsigned long long)arg2;
- (void)didPressForwardButton:(id)arg1;
- (void)didPressCommentButton:(id)arg1 withType:(unsigned long long)arg2;
- (void)didPressCommentButton:(id)arg1;
- (void)didPressActionButton:(id)arg1 atIndex:(unsigned long long)arg2 withType:(unsigned long long)arg3 andCommonButtonModel:(id)arg4;
- (void)didPressActionButton:(id)arg1;
- (void)initActionButtons;
- (_Bool)isNeedReinitActionButtons;
- (id)setupActionButtonAtIndex:(unsigned long long)arg1 withType:(unsigned long long)arg2 andCommonButtonModel:(id)arg3 andButtonName:(id)arg4;
- (id)buttonHighlightedBackgroundImage;
- (void)reloadActionButtonsUI;
- (void)reloadActionButtonUI:(id)arg1 atIndex:(unsigned long long)arg2 withType:(unsigned long long)arg3 andCommonButtonModel:(id)arg4;
- (void)refreshActionButton:(id)arg1 atIndex:(unsigned long long)arg2 withType:(unsigned long long)arg3 andCommonButtonModel:(id)arg4;
- (void)refreshActionButtons;
@property(readonly, nonatomic) _Bool shouldShowActionButtons;
- (void)setButtonsHighlighted:(_Bool)arg1;
- (void)setButtonsHidden:(_Bool)arg1;
- (void)dealloc;
@end
