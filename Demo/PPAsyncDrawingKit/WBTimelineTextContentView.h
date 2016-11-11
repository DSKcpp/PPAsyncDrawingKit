//
//  WBTimelineTextContentView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"

@class WBTimelineTableViewCellDrawingContext;
@class PPTextRenderer;

@interface WBTimelineTextContentView : PPAsyncDrawingView
+ (CGSize)sizeForTag:(id)arg1;
+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext userInfo:(NSDictionary *)userInfo;
@property(retain, nonatomic) NSMutableArray *attachmentViews;
@property(retain, nonatomic) NSMutableArray *attachments;
@property(nonatomic) unsigned long long touchingItemIndex;
@property(nonatomic) struct CGRect unionAreaHighlightedFeedbackFrame;
@property(nonatomic) double detaRightPading;
@property(nonatomic) double timeSourceReleventWidth;
@property(nonatomic) _Bool isSourceRectBeReset;
@property(nonatomic) _Bool customSourceColorDefault;
@property(retain, nonatomic) NSMutableArray *wb_accessibilityElements;
@property(retain, nonatomic) PPTextRenderer *metaInfoTextRenderer;
@property(nonatomic) _Bool quotedItemHighlighted;
@property(retain, nonatomic) NSMutableAttributedString *sourceInfoString;
//@property(retain, nonatomic) WBTimelineLargeCardView *largeCardView;
@property(nonatomic) _Bool disableTextLinkHighlight;
@property(retain, nonatomic) PPTextRenderer *respondTextRenderer;
@property(retain, nonatomic) PPTextRenderer *titleTextRenderer;
@property(retain, nonatomic) PPTextRenderer *quotedItemTextRenderer;
@property(retain, nonatomic) PPTextRenderer *itemTextRenderer;
//@property(nonatomic) __weak id <WBTimelineTextContentViewDelegate> delegate;
@property(nonatomic) _Bool highlighted;
@property(retain, nonatomic) WBTimelineTableViewCellDrawingContext *drawingContext;
- (void)adClickeStatisticsWithActionCode:(id)arg1;
- (long long)indexOfAccessibilityElement:(id)arg1;
- (id)accessibilityElementAtIndex:(long long)arg1;
- (long long)accessibilityElementCount;
- (void)reloadAccessibilityElements;
- (_Bool)isAccessibilityElement;
- (_Bool)shouldReloadAccessibilityElementsWhenSettingDrawingContext;
- (void)didPressSourceButton:(id)arg1 ActiveRange:(id)arg2;
- (_Bool)textRenderer:(id)arg1 shouldInteractWithActiveRange:(id)arg2;
- (void)textRenderer:(id)arg1 didPressActiveRange:(id)arg2;
- (id)timelineURLForScheme:(id)arg1;
- (id)schemeForMiniCardActiveRange:(id)arg1 andAttributedText:(id)arg2;
- (void)pressedActiveRange:(id)arg1 inText:(id)arg2;
- (void)otherTouchableItemLongPressed:(unsigned long long)arg1;
- (void)otherTouchableItemPressed:(unsigned long long)arg1 params:(id)arg2;
- (void)didPressVideoCard;
- (void)largeCardPressed:(id)arg1;
- (_Bool)checkCanEnterPageInfo:(id)arg1 withScheme:(id)arg2;
- (struct CGRect)pressedItemAttachmentPointIsQuoted:(_Bool)arg1 Rect:(struct CGRect)arg2;
- (struct CGRect)pressedItemaAttachmentPointInWindow:(id)arg1;
- (void)pressedTimelineURL:(id)arg1;
- (void)textRenderer:(id)arg1 placeAttachment:(id)arg2 frame:(struct CGRect)arg3 context:(struct CGContext *)arg4;
- (id)activeRangesForTextRenderer:(id)arg1;
- (id)contextViewForTextRenderer:(id)arg1;
- (id)rendererAtPoint:(struct CGPoint)arg1;
@property(readonly, nonatomic) NSArray *textRenderers;
- (void)longTouchAtPoint:(id)arg1;
- (void)touchesCancelled:(id)arg1 withEvent:(id)arg2;
- (void)touchesMoved:(id)arg1 withEvent:(id)arg2;
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2;
- (void)checkNeedToDrawUnionAreaHightlightedFeedback:(id)arg1;
- (void)touchesBegan:(id)arg1 withEvent:(id)arg2;
- (void)removeAttachmentViews;
- (void)addAttachmentViews;
@property(nonatomic) _Bool enableAsyncDrawing; // @synthesize enableAsyncDrawing=_enableAsyncDrawing;
- (void)drawingDidFinishAsynchronously:(_Bool)arg1 success:(_Bool)arg2;
- (void)drawingWillStartAsynchronously:(_Bool)arg1;
- (_Bool)drawInRect:(struct CGRect)arg1 withContext:(struct CGContext *)arg2 asynchronously:(_Bool)arg3 userInfo:(id)arg4;
- (id)currentDrawingUserInfo;
- (void)resetSourceInfoStringWidth:(double)arg1 right:(double)arg2;
- (void)drawMetaInfoWithTimelineItem:(id)arg1 InRect:(struct CGRect)arg2 withContext:(struct CGContext *)arg3 initialDrawingCount:(unsigned long long)arg4;
- (double)titleItemTextMaxWidth;
- (void)setupMetaInfoRenderer:(id)arg1 timelineItem:(id)arg2;
- (id)memberIconImageNameForTimelineItem:(id)arg1;
- (void)setDrawingContextWithIsNotCustomSource:(_Bool)arg1;
- (id)attributedStringIgnoreActiveRangeColorForAttributedString:(id)arg1;
@property(readonly, nonatomic) _Bool reduceDrawingContents;
- (unsigned long long)touchingOtherTouchableItemIndex:(struct CGPoint)arg1 finishBlock:(id)arg2;
- (struct CGRect)otherTouchableItemFrameOfPoint:(struct CGPoint)arg1;
- (void)dealloc;
- (id)initWithFrame:(struct CGRect)arg1;

- (id)pageInfoIdentifier;
- (void)textRenderer:(id)arg1 didPressActiveRange:(id)arg2;
- (id)activeRangesForTextRenderer:(id)arg1;
- (id)commentAttributedTextForTextRenderer:(id)arg1;
- (unsigned long long)touchingOtherTouchableItemIndex:(struct CGPoint)arg1 finishBlock:(id)arg2;
- (void)touchesCancelled:(id)arg1 withEvent:(id)arg2;
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2;
- (void)touchesBegan:(id)arg1 withEvent:(id)arg2;
- (id)textRenderers;
- (void)recentCommentsPressed;
- (struct CGRect)recentCommentsTouchingArea;
- (void)setDrawingContext:(id)arg1;
- (_Bool)drawInRect:(struct CGRect)arg1 withContext:(struct CGContext *)arg2 asynchronously:(_Bool)arg3 userInfo:(id)arg4;
+ (void)renderDrawingContextForRecentComments:(id)arg1 userInfo:(id)arg2;
+ (void)renderDrawingContextForUnionArea:(id)arg1 userInfo:(id)arg2;
+ (id)recentCommentAttributedTextsWithStringArray:(id)arg1;
+ (id)forwardStatusAttributedTextsOfUnionAreaFrom:(id)arg1;
+ (id)statisticsStringWithNumberForLongStr:(long long)arg1;
+ (id)statisticsStringWithNumber:(long long)arg1;
@property(retain, nonatomic) PPTextRenderer *commentCountSummaryRender; // @synthesize commentCountSummaryRender=_commentCountSummaryRender;
@property(retain, nonatomic) NSMutableArray *commentSummaryTextRenderers; // @synthesize commentSummaryTextRenderers=_commentSummaryTextRenderers;
@property(retain, nonatomic) NSMutableArray *forwardSummaryTextRendersers; // @synthesize forwardSummaryTextRendersers=_forwardSummaryTextRendersers;
@property(retain, nonatomic) PPTextRenderer *forwardSummaryRender; // @synthesize forwardSummaryRender=_forwardSummaryRender;
@property(retain, nonatomic) PPTextRenderer *likeSummaryRender; // @synthesize likeSummaryRender=_likeSummaryRender;
@property(retain, nonatomic) NSMutableArray *commentTextRenderers; // @synthesize commentTextRenderers=_commentTextRenderers;
@end
