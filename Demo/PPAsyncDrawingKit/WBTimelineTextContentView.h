//
//  WBTimelineTextContentView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"
#import "WBTimelineLargeCardView.h"
#import "PPIsomerismTextView.h"

@class WBTimelineTableViewCellDrawingContext;
@class WBTimelineItem;

@interface WBTimelineTextContentView : PPIsomerismTextView
+ (CGSize)sizeForTag:(id)arg1;
+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext;
@property (nonatomic, strong) NSMutableArray *attachmentViews;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, assign) unsigned long long touchingItemIndex;
@property (nonatomic, assign) CGRect unionAreaHighlightedFeedbackFrame;
@property (nonatomic, assign) double detaRightPading;
@property (nonatomic, assign) double timeSourceReleventWidth;
@property (nonatomic, assign) BOOL isSourceRectBeReset;
@property (nonatomic, assign) BOOL customSourceColorDefault;
@property (nonatomic, assign) BOOL quotedItemHighlighted;
@property (nonatomic, strong) NSMutableAttributedString *sourceInfoString;
@property (nonatomic, strong) WBTimelineLargeCardView *largeCardView;
@property (nonatomic, assign) BOOL disableTextLinkHighlight;
@property (nonatomic, strong) PPTextRenderer *metaInfoTextRenderer;
@property (nonatomic, strong) PPTextRenderer *titleTextRenderer;
@property (nonatomic, strong) PPTextRenderer *quotedItemTextRenderer;
@property (nonatomic, strong) PPTextRenderer *itemTextRenderer;
//@property (nonatomic, assign) __weak id <WBTimelineTextContentViewDelegate> delegate;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) WBTimelineTableViewCellDrawingContext *drawingContext;
- (void)adClickeStatisticsWithActionCode:(id)arg1;
- (long long)indexOfAccessibilityElement:(id)arg1;
- (id)accessibilityElementAtIndex:(long long)arg1;
- (long long)accessibilityElementCount;
- (void)reloadAccessibilityElements;
- (BOOL)isAccessibilityElement;
- (BOOL)shouldReloadAccessibilityElementsWhenSettingDrawingContext;
- (void)didPressSourceButton:(id)arg1 ActiveRange:(id)arg2;
- (id)timelineURLForScheme:(id)arg1;
- (id)schemeForMiniCardActiveRange:(id)arg1 andAttributedText:(id)arg2;
- (void)pressedActiveRange:(id)arg1 inText:(id)arg2;
- (void)otherTouchableItemLongPressed:(unsigned long long)arg1;
- (void)otherTouchableItemPressed:(unsigned long long)arg1 params:(id)arg2;
- (void)didPressVideoCard;
- (void)largeCardPressed:(id)arg1;
- (BOOL)checkCanEnterPageInfo:(id)arg1 withScheme:(id)arg2;
- (struct CGRect)pressedItemAttachmentPointIsQuoted:(BOOL)arg1 Rect:(struct CGRect)arg2;
- (struct CGRect)pressedItemaAttachmentPointInWindow:(id)arg1;
- (void)pressedTimelineURL:(id)arg1;
- (void)textRenderer:(id)arg1 placeAttachment:(id)arg2 frame:(struct CGRect)arg3 context:(struct CGContext *)arg4;
- (void)longTouchAtPoint:(id)arg1;
- (void)checkNeedToDrawUnionAreaHightlightedFeedback:(id)arg1;
- (void)removeAttachmentViews;
- (void)addAttachmentViews;
@property (nonatomic, assign) BOOL enableAsyncDrawing;
- (void)resetSourceInfoStringWidth:(double)arg1 right:(double)arg2;
- (double)titleItemTextMaxWidth;
- (id)memberIconImageNameForTimelineItem:(id)arg1;
- (void)setDrawingContextWithIsNotCustomSource:(BOOL)arg1;
- (id)attributedStringIgnoreActiveRangeColorForAttributedString:(id)arg1;
@property(readonly, nonatomic) BOOL reduceDrawingContents;
- (NSUInteger)touchingOtherTouchableItemIndex:(CGPoint)point finishBlock:(void(^)(void))finishBlock;
- (struct CGRect)otherTouchableItemFrameOfPoint:(struct CGPoint)arg1;
- (void)dealloc;

- (id)pageInfoIdentifier;


- (void)recentCommentsPressed;
- (struct CGRect)recentCommentsTouchingArea;
- (void)setDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext;
+ (void)renderDrawingContextForRecentComments:(id)arg1 userInfo:(id)arg2;
+ (void)renderDrawingContextForUnionArea:(id)arg1 userInfo:(id)arg2;
+ (id)recentCommentAttributedTextsWithStringArray:(id)arg1;
+ (id)forwardStatusAttributedTextsOfUnionAreaFrom:(id)arg1;
+ (id)statisticsStringWithNumberForLongStr:(long long)arg1;
+ (id)statisticsStringWithNumber:(long long)arg1;
@end
